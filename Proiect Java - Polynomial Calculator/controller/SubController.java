package org.example.controller;

import org.example.model.Operatii;
import org.example.model.Polinom;

import javax.swing.*;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

public class SubController implements ActionListener{

    private JTextField polinomField1;
    private JTextField polinomField2;

    private JTextField result;

    public SubController(JTextField polinomField1, JTextField polinomField2, JTextField result) {
        this.polinomField1 = polinomField1;
        this.polinomField2 = polinomField2;
        this.result = result;
    }

    public void actionPerformed(ActionEvent e) {

        String polinomText1 = polinomField1.getText();
        String polinomText2 = polinomField2.getText();

        Polinom polinom1 = Polinom.convertStringToPolinom(polinomText1);
        Polinom polinom2 = Polinom.convertStringToPolinom(polinomText2);

        Polinom rezultat = Operatii.substraction(polinom1, polinom2);
        //System.out.println("Rezultatul scaderii: " + result.toString());
        result.setText(rezultat.toString());

        System.out.println("SUBSTRACTION!");

    }
}
