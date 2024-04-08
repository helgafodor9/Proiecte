package org.example.model;


public class App
{
    public static void main( String[] args )
    {
        /*
         Polinom p = new Polinom();
         p.addMonom(5, 4.0);
         p.addMonom(4, -3.0 );
         p.addMonom(2, 1.0);
         p.addMonom(1, -8.0);
         p.addMonom(0, 1.0);

         Polinom q = new Polinom();
         q.addMonom(4, 3.0 );
         q.addMonom(3, -1.0);
         q.addMonom(2, 1.0);
         q.addMonom(1, 2.0);
         q.addMonom(0, -1.0);

         System.out.print("Suma:");
         Polinom result_sum = new Polinom();
         result_sum = Operatii.addition(p,q);

         for(Integer putere : result_sum.getPolinom().keySet()){
             double coeficient = result_sum.getValueCoeficient(putere);
             if(coeficient != 0.0)
                  System.out.print(coeficient + "X^" + putere + " ");
         }

        System.out.println();

        System.out.print("Diferenta:");
        Polinom result_substraction = new Polinom();
        result_substraction = Operatii.substraction(p,q);

        for(Integer putere : result_substraction.getPolinom().keySet()){
            double coeficient = result_substraction.getValueCoeficient(putere);
            if(coeficient != 0.0)
                System.out.print(coeficient + "X^" + putere + " ");
        }

        System.out.println();

        Polinom p1 = new Polinom();
        p1.addMonom(2, 3.0);
        p1.addMonom(1, -1.0);
        p1.addMonom(0, 1.0);

        Polinom q1 = new Polinom();
        q1.addMonom(1, 1.00);
        q1.addMonom(0, -2.00);


        System.out.print("Inmultire:");
        Polinom result_multiplication = new Polinom();
        result_multiplication = Operatii.multiplication(p1,q1);

        for(Integer putere : result_multiplication.getPolinom().keySet()){
            double coeficient = result_multiplication.getValueCoeficient(putere);
            if(coeficient != 0.0)
                System.out.print(coeficient + "X^" + putere + " ");
        }

        System.out.println();

        Polinom p2 = new Polinom();
        p2.addMonom(3, 1.0);
        p2.addMonom(2, -2.0);
        p2.addMonom(1, 6.0);
        p2.addMonom(0, -5.0);

        System.out.print("Derivata:");
        Polinom result_derivative = new Polinom();
        result_derivative = Operatii.derivative(p2);

        for(Integer putere : result_derivative.getPolinom().keySet()){
            double coeficient = result_derivative.getValueCoeficient(putere);
            if(coeficient != 0.0)
                System.out.print(coeficient + "X^" + putere + " ");
        }

        System.out.println();

        Polinom p3 = new Polinom();
        p3.addMonom(0, 5.0);
        p3.addMonom(2, 4.0);
        p3.addMonom(3, 1.0);

        System.out.print("Integrala:");
        Polinom result_integral = new Polinom();
        result_integral = Operatii.integral(p3);

        for(Integer putere : result_integral.getPolinom().keySet()){
            double coeficient = result_integral.getValueCoeficient(putere);
            String rez_coef = String.format("%.2f", coeficient);
            if(coeficient != 0.0)
                System.out.print(rez_coef + "X^" + putere + " ");
        }


         */
        //System.out.println();


        Polinom p4 = new Polinom();
        p4.addMonom(0, -5.0);
        p4.addMonom(1, 6.0);
        p4.addMonom(2, -2.0);
        p4.addMonom(3, 1.0);

        Polinom q4 = new Polinom();
        q4.addMonom(0, -1.0);
        q4.addMonom(2, 1.0);

        System.out.print("Impartirea:");
        Polinom result_divide = new Polinom();
        result_divide = Operatii.divide(p4, q4);

        System.out.println(result_divide.toString());


        /*
        String exp1 = "4x^5-3x^4+x^2-8x+1";
        String exp2 = "3x^5-x^3+x^2+2x-1";
        Polinom rezultat1 = Polinom.convertStringToPolinom(exp1);
        Polinom rezultat2 = Polinom.convertStringToPolinom(exp2);
        System.out.println(rezultat1);
        System.out.println(rezultat2);

         */

    }
}
