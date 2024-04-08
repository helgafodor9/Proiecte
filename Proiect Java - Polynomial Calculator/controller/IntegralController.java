package org.example.controller;

import org.example.model.Operatii;
import org.example.model.Polinom;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class IntegralController implements ActionListener {

    private JTextField polinomField;

    private JTextField result;

    public IntegralController(JTextField polinomField, JTextField result) {
        this.polinomField = polinomField;
        this.result = result;
    }

    public void actionPerformed(ActionEvent e) {

        String polinomText = polinomField.getText();

        Polinom polinom = Polinom.convertStringToPolinom(polinomText);

        Polinom rezultat = Operatii.integral(polinom);
        //System.out.println("Rezultatul integrarii: " + result.toString());
        result.setText(rezultat.toString());

        System.out.println("INTEGRAL!");

    }

}
