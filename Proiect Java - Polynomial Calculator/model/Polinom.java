package org.example.model;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class Polinom {

    private Map<Integer, Double> polinom = new HashMap<>();

    public Polinom(Map<Integer, Double> polinom) {
        this.polinom = polinom;
    }

    public Polinom() {
    }

    public Map<Integer, Double> getPolinom() {
        return polinom;
    }

    public void setPolinom(Map<Integer, Double> polinom) {
        this.polinom = polinom;
    }

    public void addMonom(Integer keyPutere, Double valueCoeficient){
        polinom.put(keyPutere, valueCoeficient);
    }

    public Double getValueCoeficient(Integer keyPutere){
        return polinom.get(keyPutere);
    }


    @Override
    public String toString() {

        StringBuilder stringBuilder = new StringBuilder();
        boolean isFirstMonom = true;

        for (Integer power : this.getPolinom().keySet()) {

            double coeficient = this.getValueCoeficient(power);

            if (coeficient != 0.0) {
                if (!isFirstMonom) {
                    if (coeficient > 0) {
                        stringBuilder.append("+");
                    }
                    else
                    {
                        stringBuilder.append("-");
                    }
                } else {
                    isFirstMonom = false;
                }

                String coefString = String.format("%.2f", coeficient);
                if (power == 0) {
                    stringBuilder.append(coefString);
                } else {
                    stringBuilder.append(coefString).append("x^").append(power);
                }
            }
        }

        return stringBuilder.toString();
    }

    public static Polinom convertStringToPolinom(String text) {

        Pattern pattern = Pattern.compile("([+-]?\\d*\\.?\\d*)x\\^?(\\d+)?|([+-]\\d)");
        Matcher matcher = pattern.matcher(text);
        Polinom polinom = new Polinom();

        while (matcher.find()) {

            double coeficient;
            int putere;

            String coeficientString = matcher.group(1);
            String putereString = matcher.group(2);
            String termenLiberString = matcher.group(3);

            if (coeficientString == null || coeficientString.equals("+") || coeficientString.isEmpty()) {
                coeficient = 1.0;
            } else if (coeficientString.equals("-")) {
                coeficient = -1.0;
            } else {
                coeficient = Double.parseDouble(coeficientString);
            }

            if (putereString != null) {
                putere = Integer.parseInt(putereString);
            } else {
                putere = 1;
            }

            if (termenLiberString != null) {
                coeficient = Double.parseDouble(termenLiberString);
                putere = 0;
            }


            polinom.addMonom(putere, coeficient);
        }

        return polinom;
    }

}
