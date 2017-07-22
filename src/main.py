
import subprocess as sp
import os
import re
import argparse
import logging

'''
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

                                    R E P H L E X - R U N T I M E  I N J E C T I O N  T O O L 

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

@ description: The tool on hand injects custom code into Android applications during runtime, its strategy is the subsequent:
                    
                    - Patch the original APK to insert a newInstance field and a getInstance() method for it in the target
                      class file. 
                    
                    - Patch the target class with a new method called loadInjection() which is always used before the
                      getInstance() method returns the newInstance field to refresh/update it before
                    
                    - The loadInjection() method loads a DEX file during runtime which is in turn responsible for 
                      replacing certain fields or methods of the target class.
                    
                    - Original calls found in the APK are patched to be invoked on the newInstance field like so:
                        targetClassObject.targetMethod()    ====>    TargetClass.getInstance(targetClassObject).targetMethod()

                    - The patched APK file is installed and run on the device.

                Since the APP has not to be restarted as it reinjects the DEX during runtime for every target method call, 
                merely the DEX application has to be rebuilt and redeployed thus resulting in a runtime code injection mechanic.

                Due to a current apktool bug, the buildtoolversions of the target APK should be below 25.

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

@ author: Philipp Rieger
@ date: January 2017

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Sample call:

python src/main.py   --apk_path ../apks/RephlexDemo.apk
                     --target_pkg com.conti.its.philipp.rephlexdemo 
                     --target_class com.conti.its.philipp.rephlexdemo.LoginVerifier 
                     --target_method verifyLogin 
                     --r


In addition, the Injector.java class is to be adjusted for the required needs !

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'''

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

logging.basicConfig(level=logging.DEBUG,
                    format='%(asctime)s %(message)s') 

FNULL = open(os.devnull, 'w')

BASE_PATH = "/".join(os.path.dirname(os.path.abspath(__file__)).split('/')[:-1])

apk_path = None
base_package = None
target_class   = None
target_method  = None

def decompile_apk():
    ''' decompiles the APK with apktool '''
    logging.info(bcolors.OKBLUE + "[INFO] Disassembling the APK file ..." + bcolors.ENDC)
    apktool_jar_path = os.path.join(BASE_PATH, 'tools', 'apktool.jar')
    output_path = os.path.join(BASE_PATH, 'output', apk_path.split('/')[-1])
    
    sp.call(['java', '-jar', apktool_jar_path, 'd', apk_path, '-o', output_path, '-f' ], stdout=FNULL, stderr=sp.STDOUT)
    logging.info(bcolors.OKBLUE + '[INFO] Done.' + bcolors.ENDC)

def patch_injection_loader(apk_name):
    ''' patches the injection loading class as well as the newInstance field and getInstance() methods into target class '''
    logging.info(bcolors.OKBLUE + "[INFO] Patching the original APK..." + bcolors.ENDC)
    smali_patch_class = 'L' + target_class.replace('.', '/') + ';'
    source_file_path = os.path.join(BASE_PATH, 'output', apk_name, 'smali', smali_patch_class[1:-1]) + '.smali'
    field_declaration_path = os.path.join(BASE_PATH, 'tools', 'smali_newInstance_field.txt')
    method_declaration_path = os.path.join(BASE_PATH, 'tools', 'smali_injection_method.txt')
    call_path = os.path.join(BASE_PATH, 'tools', 'smali_method_call.txt')

    ### VICTIM CLASS PATCHING
    with open(source_file_path, 'r+')       as source_file, \
         open(field_declaration_path, 'r')  as field_file, \
         open(method_declaration_path, 'r') as method_file:

        end_content = []
        content = source_file.read()
        if "loadInjection" in content:
            print("[INFO] Nothing to patch, already contains the injector")
            return
        content = content.split('\n')
        does_have_static_fields = '# static fields' in content

        # patch victim class
        for line in content:
            end_content.append(line)
            # add the newInstance static field
            if does_have_static_fields and line == '# static fields':
                line_to_add = field_file.read().replace('######', smali_patch_class)
                end_content.append(line_to_add)
            if not does_have_static_fields and line.startswith('.source'):
                line_to_add = field_file.read().replace('######', smali_patch_class)
                end_content.append('\n\n#static fields')
                end_content.append(line_to_add)
            # add injection method and getInstance method
            elif line == '# direct methods':
                lines_to_add = method_file.read().replace('######', smali_patch_class).replace('###pkg###', base_package)
                end_content.append(lines_to_add + "\n")

        end_content = "\n".join(end_content)
        source_file.seek(0)
        source_file.write(end_content)


    ### PATCH ALL CALLS TO THE VICTIM METHOD
    patch_calls(apk_name)

    logging.info(bcolors.OKBLUE + '[INFO] Done.' + bcolors.ENDC)


def patch_calls(apk_name):
    ''' patches the calls to the original method in all source files '''
    smali_patch_class = 'L' + target_class.replace('.', '/') + ';'
    call_path = os.path.join(BASE_PATH, 'tools', 'smali_method_call.txt')
    search_string = smali_patch_class +  '->' + target_method

    with open(call_path, 'r') as call_file:
        source_file_path = os.path.join(BASE_PATH, 'output', apk_name, 'smali', '/'.join(base_package.split('.')))
        for path, subdirs, files in os.walk(source_file_path):
            for name in files:
                with open(os.path.join(path, name), 'r+') as source_file:
                    content = source_file.read()
                    # check if a call is in here
                    if search_string in content:
                        content = content.split('\n')

                        ### ACTUAL CALL PATCHING
                        methods_to_patch = find_call_sections(content)
                        for method_name, method_dict in methods_to_patch.items():
                            m = re.match('.*\.(.*)\s(\d+).*', content[method_dict['register_line_index']])
                            register_type = m.group(1)
                            register_amount = int(m.group(2))
                            parameter_amount = determine_parameter_amount(method_dict['section'])

                            # determine the new register that can be safely used
                            if register_type == 'locals':
                                target_register = 'v' + str(register_amount)
                            elif register_type == 'registers':
                                target_register = 'v' + str(register_amount - parameter_amount)

                            # patch register line
                            content[method_dict['register_line_index']] = re.sub('\d+', str(register_amount + 1), content[method_dict['register_line_index']])

                            # patch all calls from original to use the injected newInstance
                            for call_index in method_dict['calls']:
                                register_holding_object = re.match('.*invoke-virtual\s\{(\w\d+).*', content[call_index]).group(1)
                                content[call_index] = content[call_index].replace('invoke-virtual {' + register_holding_object, 'invoke-virtual {' + target_register)
                                lines_to_insert = call_file.read().replace('######', smali_patch_class).replace('###org###', register_holding_object).replace('###dst###', target_register)
                                content.insert(call_index - 1, lines_to_insert)

                            methods_to_patch = adjust_line_offset(methods_to_patch, method_name)

                        content = "\n".join(content)
                        source_file.seek(0)
                        source_file.write(content)


def adjust_line_offset(methods_to_patch, just_patched_method_name):
    ''' adjusts the line offset in the list due to insertion of new lines '''
    for method_name, method_dict in methods_to_patch.items():
        if not method_name == just_patched_method_name:
            if method_dict['start_index'] > methods_to_patch[just_patched_method_name]['start_index']:
                # the method is after the just patched one, so increment its indices since we inserted a line
                method_dict['start_index'] += 4
                method_dict['end_index'] += 4
                method_dict['first_dot_line_index'] += 4
                method_dict['register_line_index'] += 4
                method_dict['calls'] = [line + 3 for line in method_dict['calls']]
    return methods_to_patch


def find_call_sections(content):
    ''' finds all the call sections where the target method is invoked '''
    smali_patch_class = 'L' + target_class.replace('.', '/') + ';'
    search_string = smali_patch_class + '->' + target_method
    methods_to_patch = {}

    current_line_index = 0
    while current_line_index < len(content):

        if search_string in content[current_line_index]:

            ###### a call is found ######

            # find method start and first .line directive
            tmp_for_start_search = content[:current_line_index]
            tmp_for_start_search.reverse()
            start_method_index, first_dot_line_directive_index, register_line_index = None, None, None
            line_counter = current_line_index-1
            for l in tmp_for_start_search:
                if '.method' in l:
                    start_method_index = line_counter
                if '.locals' in l or '.registers' in l:
                    register_line_index = line_counter
                if first_dot_line_directive_index is None and '.line' in l:
                    first_dot_line_directive_index = line_counter
                if start_method_index and first_dot_line_directive_index and register_line_index:
                    # everything found in this list
                    break
                line_counter -= 1 # since going in reverse

            # find method end
            line_counter = current_line_index
            tmp_for_end_search = content[current_line_index:]
            end_method_index = None
            for l in tmp_for_end_search:
                if '.end method' in l:
                    end_method_index = line_counter
                if end_method_index:
                    # everything found in this list
                    break
                line_counter += 1

            method_section = content[start_method_index : end_method_index + 1]

            # determine method name
            method_name = re.match('\.method\s.*\s(.*)\(.*\).*', method_section[0]).group(1)

            # find all the calls in the method
            calls = []
            for l in method_section:
                if search_string in l:
                    calls.append(content.index(l))

            # save in the dict
            methods_to_patch[method_name] = {
                'section' : method_section,
                'start_index' : start_method_index,
                'end_index' : end_method_index,
                'first_dot_line_index' : first_dot_line_directive_index,
                'register_line_index' : register_line_index,
                'calls' : calls,
            }

            # move line cursor of outer loop to the end of this method, to not visit it again
            current_line_index = end_method_index

        current_line_index += 1

    return methods_to_patch


def determine_parameter_amount(method_content):
    ''' determines the amount of parameters of the method '''
    amount = 0
    for line in method_content:
        if '.param' in line:
            amount = int(re.match('.*\.param p(\d+).*', line).group(1))
    return amount + 1 # this is the first implicit p0 param


def rebuild_apk(apk_name):
    ''' rebuilds the patched APK '''
    logging.info(bcolors.OKBLUE + '[INFO] Rebuilding and signing patched APK...' + bcolors.ENDC)
    # rebuild
    apktool_jar_path = os.path.join(BASE_PATH, 'tools', 'apktool.jar')
    apk_apktool_path = os.path.join(BASE_PATH, 'output', apk_name)
    output_path = os.path.join(BASE_PATH, 'output', apk_name.split('.')[0] + '_patched.apk')
    sp.call(['java', '-jar', apktool_jar_path, 'b', apk_apktool_path, '-o', output_path], stdout=FNULL, stderr=sp.STDOUT)
    # sign
    sign_jar_path = os.path.join(BASE_PATH, 'tools', 'sign.jar')
    apk_to_sign = os.path.join(BASE_PATH, 'output', apk_name.split('.')[0] + '_patched.apk')
    sp.call(['java', '-jar', sign_jar_path, 'b', apk_to_sign, '--override'], stdout=FNULL, stderr=sp.STDOUT)
    logging.info(bcolors.OKBLUE + '[INFO] Done.' + bcolors.ENDC)


def reinstall_apk(apk_name):
    ''' reinstalls the patched APK onto the device '''
    logging.info(bcolors.OKBLUE + '[INFO] Reinstalling the patched APK...' + bcolors.ENDC)
    patched_apk_path = os.path.join(BASE_PATH, 'output', apk_name.split('.')[0] + '_patched.apk')
    sp.call(['adb', 'uninstall', base_package], stdout=FNULL, stderr=sp.STDOUT)
    sp.call(['adb', 'install', patched_apk_path], stdout=FNULL, stderr=sp.STDOUT)
    logging.info(bcolors.OKBLUE + '[INFO] Done.' + bcolors.ENDC)


def assemble_injector_dex(dex_template_path):
    ''' builds the APK file of the dex project '''
    logging.info(bcolors.OKBLUE + '[INFO] Building DEX project...' + bcolors.ENDC)
    sp.call([os.path.join(dex_template_path, "gradlew"), 'assemble', '-p', dex_template_path], stdout=FNULL, stderr=sp.STDOUT)
    logging.info(bcolors.OKBLUE + '[INFO] Done.' + bcolors.ENDC)


def deploy_injector_dex(dex_template_path):
    ''' deploys the DEX onto the emulator '''
    logging.info(bcolors.OKBLUE + '[INFO] Deploying the DEX project...' + bcolors.ENDC)
    injector_apk_path = os.path.join(dex_template_path, 'app', 'build', 'outputs', 'apk', 'app-debug.apk')
    dex_dir = os.path.join('data', 'local', 'tmp', 'testjars')
    sp.call(['adb', 'shell', 'mkdir', dex_dir], stdout=FNULL, stderr=sp.STDOUT)
    sp.call(['adb', 'push', injector_apk_path, os.path.join(dex_dir, 'injector.apk')], stdout=FNULL, stderr=sp.STDOUT)
    logging.info(bcolors.OKBLUE + '[INFO] Done.' + bcolors.ENDC)



def main():
    global base_package, target_class, target_method, apk_path

    parser = argparse.ArgumentParser(description='Runtime Code Injection Tool for APKs')
    parser.add_argument('--apk_path', dest='apk_path', help='Path to your APK file', required=True)
    parser.add_argument('--target_pkg', dest='target_pkg', help='Package of target application', required=True)
    parser.add_argument('--target_class', dest='target_class', help='Class to instrument of target application', required=True)
    parser.add_argument('--target_method', dest='target_method', help='Method to instrument of target class', required=True)
    parser.add_argument('--r', dest='rebuild', help='DEX is rebuilt and redeployed', action='store_true')
    parser.add_argument('--ro', dest='rebuild_only', help='Only rebuild and redeploy DEX', action='store_true')

    args = parser.parse_args()
    apk_path = args.apk_path
    base_package = args.target_pkg
    target_class = args.target_class
    target_method = args.target_method
    rebuild = args.rebuild
    rebuild_only = args.rebuild_only

    dex_template_path = os.path.join(BASE_PATH, 'tools', 'Injector-DEX-Project', 'DexToLoad')

    if not rebuild_only:
        apk_name = apk_path.split('/')[-1]
        decompile_apk()
        patch_injection_loader(apk_name)
        rebuild_apk(apk_name)
        reinstall_apk(apk_name)

    if rebuild or rebuild_only:
        assemble_injector_dex(dex_template_path)
        deploy_injector_dex(dex_template_path)


if __name__ == "__main__":
    main()