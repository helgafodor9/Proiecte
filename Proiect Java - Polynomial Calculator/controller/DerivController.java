package org.example.controller;

import org.example.model.Operatii;
import org.example.model.Polinom;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class DerivController implements ActionListener {

    private JTextField polinomField;

    private JTextField result;

    public DerivController(JTextField polinomField, JTextField result) {

        this.polinomField = polinomField;
        this.result = result;
    }

    public void actionPerformed(ActionEvent e) {

        String polinomText = polinomField.getText();

        Polinom polinom = Polinom.convertStringToPolinom(polinomText);

        Polinom rezultat = Operatii.derivative(polinom);
        //System.out.println("Rezultatul derivarii: " + result.toString());
        result.setText(rezultat.toString());

        System.out.println("DERIVATIVE!");

    }

}
