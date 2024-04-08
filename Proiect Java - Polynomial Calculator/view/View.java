package org.example.view;

import org.example.controller.*;

import javax.swing.*;

public class View extends JFrame{
    private JPanel panel;
    private JButton buttonAdd;
    private JButton buttonIntegral;
    private JButton buttonSub;
    private JButton buttonDivision;
    private JButton buttonMul;
    private JButton buttonDerivative;
    private JButton buttonClear;
    private JTextField textFieldPolinom1;
    private JTextField textFieldPolinom2;
    private JTextField textFieldRezultat;
    private JLabel labelPolinom1;
    private JLabel labelPolinom2;
    private JLabel labelRezultat;

    public View(){
        setTitle("Polynomial Calculator");
        setSize(900, 700);
        setContentPane(panel);
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);

        buttonAdd.addActionListener(new AddController(textFieldPolinom1, textFieldPolinom2, textFieldRezultat));
        buttonSub.addActionListener(new SubController(textFieldPolinom1, textFieldPolinom2, textFieldRezultat));
        buttonMul.addActionListener(new MulController(textFieldPolinom1, textFieldPolinom2, textFieldRezultat));
        buttonDerivative.addActionListener(new DerivController(textFieldPolinom1, textFieldRezultat));
        buttonIntegral.addActionListener(new IntegralController(textFieldPolinom1, textFieldRezultat));
        buttonDivision.addActionListener(new DivideController(textFieldPolinom1, textFieldPolinom2, textFieldRezultat));

        buttonClear.addActionListener(new ClearController(textFieldRezultat));

        setVisible(true);

    }

    /*private void initGUIComponents(){

        setLayout(new GridBagLayout());

        panel = new JPanel();
        panel.setLayout(new GridBagLayout());

        labelPolinom1 = new JLabel("Primul polinom:");
        panel.add(labelPolinom1);
        textFieldPolinom1 = new JTextField();
        panel.add(textFieldPolinom1);

        labelPolinom2 = new JLabel("Al doilea polinom");
        panel.add(labelPolinom2);
        textFieldPolinom2 = new JTextField();
        panel.add(textFieldPolinom2);

        labelRezultat = new JLabel("Rezultat");
        panel.add(labelRezultat);

    }
    */

}
