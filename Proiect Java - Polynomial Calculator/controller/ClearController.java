package org.example.controller;

import java.awt.event.ActionListener;
import javax.swing.JTextField;
import java.awt.event.ActionEvent;

public class ClearController implements ActionListener {

    private JTextField textField;

    public ClearController(JTextField textField) {
        this.textField = textField;
    }

    public void actionPerformed(ActionEvent e) {
        textField.setText(""); // Șterge textul din câmpul text
    }

}
