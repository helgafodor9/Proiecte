package org.example;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;
import org.example.model.Operatii;
import org.example.model.Polinom;

/**
 * Unit test for simple App.
 */
public class OperatiiTest
    extends TestCase
{
    /**
     * Create the test case
     *
     * @param testName name of the test case
     */
    public OperatiiTest(String testName )
    {
        super( testName );
    }

    /**
     * @return the suite of tests being tested
     */
    public static Test suite()
    {
        return new TestSuite( OperatiiTest.class );
    }

    /**
     * Rigourous Test :-)
     */
    public void testApp()
    {
        assertTrue(true);
    }


    public void testAdd(){

        Polinom p1 = new Polinom();
        p1.addMonom(0, 1.0);
        p1.addMonom(1, -8.0);
        p1.addMonom(2, 1.0);
        p1.addMonom(4, -3.0);
        p1.addMonom(5, 4.0);

        Polinom p2 = new Polinom();
        p2.addMonom(0, -1.0);
        p2.addMonom(1, 2.0);
        p2.addMonom(2, 1.0);
        p2.addMonom(3, -1.0);
        p2.addMonom(4, 3.0);

        Polinom p3 = new Polinom();
        p3.addMonom(1, -6.0);
        p3.addMonom(2, 2.0);
        p3.addMonom(3, -1.0);
        p3.addMonom(5, 4.0);

        assertEquals(Operatii.addition(p1, p2).toString(), p3.toString());
    }

    public void testSub(){

        Polinom p1 = new Polinom();
        p1.addMonom(0, 1.0);
        p1.addMonom(1, -8.0);
        p1.addMonom(2, 1.0);
        p1.addMonom(4, -3.0);
        p1.addMonom(5, 4.0);

        Polinom p2 = new Polinom();
        p2.addMonom(0, -1.0);
        p2.addMonom(1, 2.0);
        p2.addMonom(2, 1.0);
        p2.addMonom(3, -1.0);
        p2.addMonom(4, 3.0);

        Polinom p3 = new Polinom();
        p3.addMonom(0, 2.0);
        p3.addMonom(1, -10.0);
        p3.addMonom(3, 1.0);
        p3.addMonom(4, -6.0);
        p3.addMonom(5, 4.0);

        assertEquals(Operatii.substraction(p1, p2).toString(), p3.toString());

    }

    public void testMul(){

        Polinom p1 = new Polinom();
        p1.addMonom(0, 1.0);
        p1.addMonom(1, -1.0);
        p1.addMonom(2, 3.0);

        Polinom p2 = new Polinom();
        p2.addMonom(0, -2.0);
        p2.addMonom(1, 1.0);

        Polinom p3 = new Polinom();
        p3.addMonom(0, -2.0);
        p3.addMonom(1, 3.0);
        p3.addMonom(2, -7.0);
        p3.addMonom(3, 3.0);

        assertEquals(Operatii.multiplication(p1, p2).toString(), p3.toString());

    }

    public void testDeriv(){

        Polinom p = new Polinom();
        p.addMonom(0, -5.0);
        p.addMonom(1, 6.0);
        p.addMonom(2, -2.0);
        p.addMonom(3, 1.0);

        Polinom p1 = new Polinom();
        p1.addMonom(0, 6.0);
        p1.addMonom(1, -4.0);
        p1.addMonom(2, 3.0);

        assertEquals(Operatii.derivative(p).toString(), p1.toString());

    }

    public void testIntegral(){

        Polinom p = new Polinom();
        p.addMonom(0, 5.0);
        p.addMonom(2, 4.0);
        p.addMonom(3, 1.0);

        Polinom p1 = new Polinom();
        p1.addMonom(1, 5.0);
        p1.addMonom(3, 1.33);
        p1.addMonom(4, 0.25);

        assertEquals(Operatii.integral(p).toString(), p1.toString());

    }
}
