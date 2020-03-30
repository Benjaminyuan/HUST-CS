public class CreateArray{
     /**
     *  创建一个不规则二维数组
     *  第一行row列
     *  第二行row - 1列
     *  ...
     *  最后一行1列
	 *	数组元素值都为默认值
     * @param row 行数
     * @return 创建好的不规则数组
     */
    public static  int[][] createArray(int row) throws Exception{
        if(row <= 0){
            throw new IllegalArgumentException("row must be a positive value");
        }
        int[][] a = new int[row][];
        for(int i=0;i<a.length;i++){
            a[i] = new int[row-i];
        }
        return a;
    }

    /**
     * 逐行打印出二维数组，数组元素之间以空格分开
     * @param a
     */
    public static  void printArray(int[][] a){
        for(int i=0;i<a.length;i++){
            for(int v : a[i]){
                System.out.print(v);
            }
            System.out.println();
        }
    }
    public static void main(String[] args) throws Exception{
        printArray(createArray(5));
    }
}