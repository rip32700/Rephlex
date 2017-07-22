package com.conti.its.philipp.rephlexdemo;

/**
 * Created by philipp on 1/27/17.
 */
public class LoginVerifier {

    private String password = "test";

    public boolean verifyLogin(String input) {
        if(input.equals(password)) {
            return true;
        } else {
            return false;
        }
    }

    public String getPassword() {
        return password;
    }
}
