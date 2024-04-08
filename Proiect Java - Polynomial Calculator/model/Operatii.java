package org.example.model;

public class Operatii {

    public static Polinom addition(Polinom p1, Polinom p2) {
        Polinom rezultat = new Polinom();

        for (Integer pow_p1 : p1.getPolinom().keySet()) {
            double coef = p1.getValueCoeficient(pow_p1);
            rezultat.addMonom(pow_p1, coef);
        }

        for (Integer pow_p2 : p2.getPolinom().keySet()) {
            double coeficient = p2.getValueCoeficient(pow_p2);
            if (rezultat.getPolinom().containsKey(pow_p2)) {
                coeficient += rezultat.getValueCoeficient(pow_p2);

                rezultat.addMonom(pow_p2, coeficient);
            }
            else
              rezultat.addMonom(pow_p2, coeficient);

        }
        return rezultat;
    }

        public static Polinom substraction (Polinom p1, Polinom p2)
        {
            Polinom rezultat = new Polinom();

            for (Integer pow_p1 : p1.getPolinom().keySet()) {
                double coef = p1.getValueCoeficient(pow_p1);
                rezultat.addMonom(pow_p1, coef);
            }

            for (Integer pow_p2 : p2.getPolinom().keySet()) {
                double coeficient = p2.getValueCoeficient(pow_p2);
                if (rezultat.getPolinom().containsKey(pow_p2)) {
                    coeficient = rezultat.getValueCoeficient(pow_p2) - coeficient;
                } else {
                    coeficient = -coeficient;
                }
                rezultat.addMonom(pow_p2, coeficient);
            }

            return rezultat;
        }

        public static Polinom multiplication (Polinom p1, Polinom p2)
        {
            Polinom rezultat = new Polinom();

            for (Integer pow_p1 : p1.getPolinom().keySet()) {
                double coef1 = p1.getValueCoeficient(pow_p1);

                for (Integer pow_p2 : p2.getPolinom().keySet()) {
                    double coef2 = p2.getValueCoeficient(pow_p2);
                    int pow = pow_p1 + pow_p2;
                    double coeficient = coef1 * coef2;

                    if (rezultat.getPolinom().containsKey(pow))
                        coeficient = coeficient + rezultat.getValueCoeficient(pow);

                    rezultat.addMonom(pow, coeficient);
                }
            }
            return rezultat;
        }

        public static Polinom derivative (Polinom p){
            Polinom rezultat = new Polinom();

            for (Integer pow : p.getPolinom().keySet()) {
                int putere = pow;
                double coef = p.getValueCoeficient(pow);
                coef = coef * putere;
                putere = putere - 1;

                rezultat.addMonom(putere, coef);
            }

            return rezultat;
        }

        public static Polinom integral (Polinom p1){
            Polinom rezultat = new Polinom();

            for (Integer pow : p1.getPolinom().keySet()) {
                int putere = pow;
                double coef = p1.getValueCoeficient(pow);
                coef = coef / (putere + 1);
                putere = putere + 1;

                rezultat.addMonom(putere, coef);
            }

            return rezultat;
        }

    private static int degree(Polinom polynomial) {
        int maxDegree = 0;
        for (int degree : polynomial.getPolinom().keySet()) {
            if (degree > maxDegree) {
                maxDegree = degree;
            }
        }
        return maxDegree;
    }

    public static Polinom divide(Polinom P, Polinom Q) {

        if (Q.getPolinom().isEmpty() || Q.getPolinom().keySet().isEmpty() || degree(Q) > degree(P)) {
            throw new IllegalArgumentException("Polynomial division not possible. The divisor is zero or has a higher degree than the dividend.");
        }

        Polinom quotient = new Polinom();
        Polinom remainder = new Polinom(P.getPolinom());

        while (degree(remainder) >= degree(Q)) {
            int degreeP = degree(remainder);
            int degreeQ = degree(Q);

            //double leadingCoefficientP = remainder.getPolinom().get(degreeP) / Q.getPolinom().get(degreeQ);
            double leadingCoefficientP = remainder.getValueCoeficient(degreeP) / Q.getValueCoeficient(degreeQ);

            quotient.addMonom(degreeP - degreeQ, leadingCoefficientP);

            Polinom temp = new Polinom();
            for (int power : Q.getPolinom().keySet()) {
                double coefQ = Q.getPolinom().get(power);
                double coefP = remainder.getPolinom().containsKey(power) ? remainder.getPolinom().get(power) : 0.0;
                double newCoefP = coefP - leadingCoefficientP * coefQ;

                if (Math.abs(newCoefP) < 1e-10) { // Considerăm coeficienții foarte mici ca fiind zero
                    temp.addMonom(power, newCoefP);
                }
            }
            remainder.setPolinom(temp.getPolinom());
        }

        System.out.println("Rest=" + remainder);

        return quotient;
    }

    }

