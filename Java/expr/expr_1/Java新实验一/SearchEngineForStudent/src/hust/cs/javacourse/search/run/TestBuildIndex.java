package hust.cs.javacourse.search.run;

import hust.cs.javacourse.search.index.AbstractDocument;
import hust.cs.javacourse.search.index.AbstractDocumentBuilder;
import hust.cs.javacourse.search.index.AbstractIndex;
import hust.cs.javacourse.search.index.impl.DocumentBuilder;
import hust.cs.javacourse.search.index.impl.Index;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.ObjectOutputStream;


/**
 * 测试索引构建
 */
public class TestBuildIndex {
    /**
     *  索引构建程序入口
     * @param args : 命令行参数
     */
    public static String docPath1 = "/Users/mac/Documents/HUST-CS/Java/expr/expr_1/Java新实验一/SearchEngineForStudent/text/1.txt";
    public static String docPath2 = "/Users/mac/Documents/HUST-CS/Java/expr/expr_1/Java新实验一/SearchEngineForStudent/text/2.txt";
    public static void main(String[] args) throws Exception {
        AbstractDocumentBuilder documentBuilder = new DocumentBuilder();
        File file1 = new File(docPath1);
        File file2 = new File(docPath2);

        AbstractDocument d1 = documentBuilder.build(1, docPath1,file1);
        AbstractDocument d2 = documentBuilder.build(2, docPath2,file2);
        System.out.println(d1.toString());
        System.out.println(d2.toString());
        
        AbstractIndex index = new Index();
        index.addDocument(d1);
        index.addDocument(d2);
        System.out.println(index.toString());
        File f = new File("./serial_index");
        if(!f.exists()){
            f.createNewFile();
        }
        FileOutputStream fileOutputStream = new FileOutputStream(f);
        ObjectOutputStream objectOutputStream = new ObjectOutputStream(fileOutputStream);
        index.writeObject(objectOutputStream);
        Index indexFromFile = new Index();
        indexFromFile.load(f);
        System.out.println("load from file-----");
        System.out.println(indexFromFile.toString());
    }
}
