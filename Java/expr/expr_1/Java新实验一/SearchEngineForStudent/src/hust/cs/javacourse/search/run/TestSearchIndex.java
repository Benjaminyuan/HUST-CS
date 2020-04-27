package hust.cs.javacourse.search.run;

import hust.cs.javacourse.search.index.impl.Term;
import hust.cs.javacourse.search.query.AbstractHit;
import hust.cs.javacourse.search.query.impl.IndexSearcher;
import hust.cs.javacourse.search.query.impl.SimpleSorter;

/**
 * 测试搜索
 */
public class TestSearchIndex {
    /**
     *  搜索程序入口
     * @param args ：命令行参数
     */
    public static void main(String[] args){
        IndexSearcher indexSearcher = new IndexSearcher();
        indexSearcher.open("./serial_index");
        SimpleSorter simpleSorter = new SimpleSorter();
        Term term = new Term();
        term.setContent("aaa");
        AbstractHit[] res = indexSearcher.search(term, simpleSorter);
        for (AbstractHit hit:res){
            System.out.println(hit.toString());
        }

    }
}
