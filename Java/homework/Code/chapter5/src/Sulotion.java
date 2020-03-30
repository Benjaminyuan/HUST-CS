package chapter5;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Random;
import java.util.stream.Stream;
import java.util.Scanner;
import java.util.ArrayList;


public class Sulotion {
    private HashSet<String> plateNumers = new HashSet<>();
    private Random random = new Random();

    public void countCharTime(String s) {
        int[] map = new int[26];
        s.toLowerCase();
        for (int i = 0; i < s.length(); i++) {
            map[s.charAt(i) - 'a']++;
        }
        for (int i = 0; i < 26; i++) {
            if (map[i] != 0) {
                System.out.print("" + (char)(i + 'a') + ":" + map[i] + "    ");
            }
        }
    }

    public String gerneratePlateNumber(int charNum, int digitsNum) {
        StringBuilder s = new StringBuilder();
        for (int i = 0; i < charNum; i++) {
            s.append((char)(getRandomNumberInRange(0, 25) + 'A'));
        }
        for (int i = 0; i < digitsNum; i++) {
            s.append((char)(getRandomNumberInRange(0, 9) + '0'));
        }
        return s.toString();
    }
    public List<String> gerneratePlateNumber(int num){
        List<String> res = new ArrayList<>();
        for(int i=0;i<num;i++){
            String temp = gerneratePlateNumber(3, 5);
            while(!plateNumers.add(temp)){
                System.out.println(temp+"is exist before");
                temp = gerneratePlateNumber(3, 5);

            }
            res.add(temp);
        }
        return res;
    }
    private int getRandomNumberInRange(int start, int end) {
        return (random.nextInt(end - start + 1) + start);
    }
    public static void main(String[] args){
        java.util.Scanner sc = new Scanner(System.in);
        Sulotion sulotion = new Sulotion();
        String s = sc.nextLine();
        sulotion.countCharTime(s);
        List<String> res = sulotion.gerneratePlateNumber(5);
        System.out.println();
        res.stream().forEach(o->System.out.println(o));
    }
}