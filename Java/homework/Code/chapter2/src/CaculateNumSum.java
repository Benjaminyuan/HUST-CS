package chapter2;

import java.lang.System;
import java.lang.System;
import java.lang.System;
import java.util.Scanner;

public class CaculateNumSum {
    public int caculate(int num) {
        int res = 0;
        if (num == 0) {
            return res;
        }
        while (num != 0) {
            res += num % 10;
            num = num / 10;
        }
        return res;
    }

    public static void main(String[] args) {
        Scanner s = new Scanner(System.in);
        System.out.println("enter a number between 0 and 1000");
        CaculateNumSum caculateNumSum = new CaculateNumSum();
        int nums = s.nextInt();
        System.out.println("your input is:"+nums);
        System.out.println("the sum of digits is:" + caculateNumSum.caculate(nums));
    }

}