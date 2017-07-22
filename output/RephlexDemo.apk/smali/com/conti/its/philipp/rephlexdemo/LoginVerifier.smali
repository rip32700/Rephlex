.class public Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;
.super Ljava/lang/Object;
.source "LoginVerifier.java"


#static fields
.field private static newInstance:Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;


# instance fields
.field private password:Ljava/lang/String;


# direct methods
.method public static getInstance(Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;)Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;
    .locals 1
    .param p0, "original"    # Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;

    .prologue
    .line 21
    invoke-static {p0}, Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;->loadInjection(Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;)V

    .line 22
    sget-object v0, Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;->newInstance:Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;

    return-object v0
.end method


.method public static loadInjection(Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;)V
    .locals 13
    .param p0, "original"    # Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;

    .prologue
    .line 42
    :try_start_0
    new-instance v4, Ljava/io/File;

    const-string v10, "data/local/tmp/testjars/injector.apk"

    invoke-direct {v4, v10}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 43
    .local v4, "file":Ljava/io/File;
    new-instance v9, Ljava/io/File;

    const-string v10, "/data/user/0/com.conti.its.philipp.rephlexdemo/outdex"

    invoke-direct {v9, v10}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 44
    .local v9, "optDexDir":Ljava/io/File;
    invoke-virtual {v9}, Ljava/io/File;->mkdirs()Z

    .line 45
    const/4 v6, 0x0

    .line 47
    .local v6, "libsPath":Ljava/lang/String;
    new-instance v2, Ldalvik/system/DexClassLoader;

    invoke-virtual {v4}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v11

    invoke-static {}, Ljava/lang/ClassLoader;->getSystemClassLoader()Ljava/lang/ClassLoader;

    move-result-object v12

    invoke-direct {v2, v10, v11, v6, v12}, Ldalvik/system/DexClassLoader;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/ClassLoader;)V

    .line 49
    .local v2, "dexClassLoader":Ldalvik/system/DexClassLoader;
    const-string v1, "com.conti.its.philipp.injector.Injector"

    .line 50
    .local v1, "completeClassName":Ljava/lang/String;
    const-string v7, "inject"

    .line 52
    .local v7, "methodToInvoke":Ljava/lang/String;
    invoke-virtual {v2, v1}, Ldalvik/system/DexClassLoader;->loadClass(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v0

    .line 53
    .local v0, "classToLoad":Ljava/lang/Class;, "Ljava/lang/Class<*>;"
    invoke-virtual {v0}, Ljava/lang/Class;->newInstance()Ljava/lang/Object;

    move-result-object v5

    .line 55
    .local v5, "instance":Ljava/lang/Object;
    const/4 v10, 0x2

    new-array v10, v10, [Ljava/lang/Class;

    const/4 v11, 0x0

    const-class v12, Ljava/lang/ClassLoader;

    aput-object v12, v10, v11

    const/4 v11, 0x1

    const-class v12, Ljava/lang/Object;

    aput-object v12, v10, v11

    invoke-virtual {v0, v7, v10}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v8

    .line 56
    .local v8, "methodToLoad":Ljava/lang/reflect/Method;
    const/4 v10, 0x2

    new-array v10, v10, [Ljava/lang/Object;

    const/4 v11, 0x0

    const-class v12, Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;

    invoke-virtual {v12}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v12

    aput-object v12, v10, v11

    const/4 v11, 0x1

    aput-object p0, v10, v11

    invoke-virtual {v8, v5, v10}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v10

    check-cast v10, Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;

    sput-object v10, Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;->newInstance:Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;
    :try_end_0
    .catch Ljava/lang/InstantiationException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/NoSuchMethodException; {:try_start_0 .. :try_end_0} :catch_2
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_3
    .catch Ljava/lang/ClassNotFoundException; {:try_start_0 .. :try_end_0} :catch_4

    .line 69
    .end local v0    # "classToLoad":Ljava/lang/Class;, "Ljava/lang/Class<*>;"
    .end local v1    # "completeClassName":Ljava/lang/String;
    .end local v2    # "dexClassLoader":Ldalvik/system/DexClassLoader;
    .end local v4    # "file":Ljava/io/File;
    .end local v5    # "instance":Ljava/lang/Object;
    .end local v6    # "libsPath":Ljava/lang/String;
    .end local v7    # "methodToInvoke":Ljava/lang/String;
    .end local v8    # "methodToLoad":Ljava/lang/reflect/Method;
    .end local v9    # "optDexDir":Ljava/io/File;
    :goto_0
    return-void

    .line 58
    :catch_0
    move-exception v3

    .line 59
    .local v3, "e":Ljava/lang/InstantiationException;
    invoke-virtual {v3}, Ljava/lang/InstantiationException;->printStackTrace()V

    goto :goto_0

    .line 60
    .end local v3    # "e":Ljava/lang/InstantiationException;
    :catch_1
    move-exception v3

    .line 61
    .local v3, "e":Ljava/lang/reflect/InvocationTargetException;
    invoke-virtual {v3}, Ljava/lang/reflect/InvocationTargetException;->printStackTrace()V

    goto :goto_0

    .line 62
    .end local v3    # "e":Ljava/lang/reflect/InvocationTargetException;
    :catch_2
    move-exception v3

    .line 63
    .local v3, "e":Ljava/lang/NoSuchMethodException;
    invoke-virtual {v3}, Ljava/lang/NoSuchMethodException;->printStackTrace()V

    goto :goto_0

    .line 64
    .end local v3    # "e":Ljava/lang/NoSuchMethodException;
    :catch_3
    move-exception v3

    .line 65
    .local v3, "e":Ljava/lang/IllegalAccessException;
    invoke-virtual {v3}, Ljava/lang/IllegalAccessException;->printStackTrace()V

    goto :goto_0

    .line 66
    .end local v3    # "e":Ljava/lang/IllegalAccessException;
    :catch_4
    move-exception v3

    .line 67
    .local v3, "e":Ljava/lang/ClassNotFoundException;
    invoke-virtual {v3}, Ljava/lang/ClassNotFoundException;->printStackTrace()V

    goto :goto_0
.end method

.method public constructor <init>()V
    .locals 1

    .prologue
    .line 6
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 8
    const-string v0, "test"

    iput-object v0, p0, Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;->password:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public getPassword()Ljava/lang/String;
    .locals 1

    .prologue
    .line 19
    iget-object v0, p0, Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;->password:Ljava/lang/String;

    return-object v0
.end method

.method public verifyLogin(Ljava/lang/String;)Z
    .locals 1
    .param p1, "input"    # Ljava/lang/String;

    .prologue
    .line 11
    iget-object v0, p0, Lcom/conti/its/philipp/rephlexdemo/LoginVerifier;->password:Ljava/lang/String;

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 12
    const/4 v0, 0x1

    .line 14
    :goto_0
    return v0

    :cond_0
    const/4 v0, 0x0

    goto :goto_0
.end method
