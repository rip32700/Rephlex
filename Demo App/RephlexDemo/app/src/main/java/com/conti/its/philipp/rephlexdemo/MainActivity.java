package com.conti.its.philipp.rephlexdemo;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {

    public static final String TAG = "RephlexDemo";

    private Button btnLogin;
    private EditText inpPw;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        inpPw = (EditText) findViewById(R.id.inpPw);

        btnLogin = (Button) findViewById(R.id.btnVerify);
        btnLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String input = inpPw.getText().toString();
                LoginVerifier verifier = new LoginVerifier();
                boolean isValid = verifier.verifyLogin(input);

                if(isValid) {
                    Log.d(TAG, "Correct password, input was >" + input + "< and correct password is" +
                            ">" + verifier.getPassword() + "<");
                    startActivity(new Intent(getApplicationContext(), WelcomeActivity.class));
                } else {
                    Log.d(TAG, "Incorrect password, input was >" + input + "< and correct password " +
                            "is >" + verifier.getPassword() + "<");
                    Toast.makeText(getApplicationContext(), "Incorrect password! Try again.",
                            Toast.LENGTH_LONG).show();
                }
            }
        });
    }
}
