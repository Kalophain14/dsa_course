package kalo.first_java_program;

public class Basics {

    public static void main(String[] args) {
        System.out.println("Hello, Kalo!");

        // basic math
        int a = 5;
        int b = 10;
        System.out.println("Sum: " + (a + b));
        System.out.println("Product: " + (a * b));

        // string
        String name = "Kalophain";
        System.out.println("Name: " + name);
        System.out.println("Name length: " + name.length());

        // loop
        System.out.println("Counting to 5:");
        for (int i = 1; i <= 5; i++) {
            System.out.println(i);
        }
    }

}