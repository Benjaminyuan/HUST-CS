package hust.cs.javacourse.search.index.impl;

import hust.cs.javacourse.search.index.AbstractDocument;
import hust.cs.javacourse.search.index.AbstractIndex;
import hust.cs.javacourse.search.index.AbstractPostingList;
import hust.cs.javacourse.search.index.AbstractPosting;
import hust.cs.javacourse.search.index.AbstractTerm;
import hust.cs.javacourse.search.index.AbstractTermTuple;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * AbstractIndex的具体实现类
 */
public class Index extends AbstractIndex {
    /**
     *
     */
    private static final long serialVersionUID = 1L;

    /**
     * 返回索引的字符串表示
     *
     * @return 索引的字符串表示
     */
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("Index:\nTermMap:\n");
        termToPostingListMapping.forEach((k,v)->{
            sb.append(String.format("%s,%s\n",k.toString(),v.toString()));
        });
        sb.append("docMap:\n");
        docIdToDocPathMapping.forEach((k,v)->{
            sb.append(String.format("docId: %d,docPath: %s\n",k,v));
        });
        return sb.toString();
    }

    /**
     * 添加文档到索引，更新索引内部的HashMap
     *
     * @param document ：文档的AbstractDocument子类型表示
     */
    @Override
    public void addDocument(AbstractDocument document) {
        if(document == null){
            return;
        }
        docIdToDocPathMapping.put(document.getDocId(),document.getDocPath());
        List<AbstractTermTuple>  tuples = document.getTuples();
        tuples.forEach(tuple ->{
            boolean shouldAdd = false;
            AbstractPostingList pl  = termToPostingListMapping.getOrDefault(tuple.term,new PostingList());
            AbstractPosting p = pl.get(pl.indexOf(document.getDocId()));
            if(p == null){
                p = new Posting(document.getDocId(),0,new ArrayList<Integer>());
                shouldAdd = true;
            }
            // 设置position
            p.setFreq(p.getFreq()+1);
            List<Integer> l = p.getPositions();
            l.add(tuple.curPos);
            p.setPositions(l);
            if(shouldAdd){
                pl.add(p);
            }
            termToPostingListMapping.put(tuple.term,pl);
        });
    }

    /**
     * <pre>
     * 从索引文件里加载已经构建好的索引.内部调用FileSerializable接口方法readObject即可
     * @param file ：索引文件
     * </pre>
     */
    @Override
    public void load(File file) {
        if(file ==  null || !file.exists()){
            return ;
        }
        try{
            ObjectInputStream in = new ObjectInputStream(new FileInputStream(file));
            readObject(in);
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    /**
     * <pre>
     * 将在内存里构建好的索引写入到文件. 内部调用FileSerializable接口方法writeObject即可
     * @param file ：写入的目标索引文件
     * </pre>
     */
    @Override
    public void save(File file) {
        if(file == null || !file.exists()){
            return;
        }
        try{
            ObjectOutputStream out = new ObjectOutputStream(new FileOutputStream(file));
            writeObject(out);
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    /**
     * 返回指定单词的PostingList
     *
     * @param term : 指定的单词
     * @return ：指定单词的PostingList;如果索引字典没有该单词，则返回null
     */
    @Override
    public AbstractPostingList search(AbstractTerm term) {
        if(term == null){
            return null;
        }
        return termToPostingListMapping.getOrDefault(term,null);
    }

    /**
     * 返回索引的字典.字典为索引里所有单词的并集
     *
     * @return ：索引中Term列表
     */
    @Override
    public Set<AbstractTerm> getDictionary() {
        return termToPostingListMapping.keySet();
    }

    /**
     * <pre>
     * 对索引进行优化，包括：
     *      对索引里每个单词的PostingList按docId从小到大排序
     *      同时对每个Posting里的positions从小到大排序
     * 在内存中把索引构建完后执行该方法
     * </pre>
     */
    @Override
    public void optimize() {
        Set<AbstractTerm> s = getDictionary();
        if(s == null|| s.size() == 0){
            return;
        }
        for(AbstractTerm term : s){
            AbstractPostingList  pl = termToPostingListMapping.get(term);
            pl.sort();
        }
    }

    /**
     * 根据docId获得对应文档的完全路径名
     *
     * @param docId ：文档id
     * @return : 对应文档的完全路径名
     */
    @Override
    public String getDocName(int docId) {
        return docIdToDocPathMapping.getOrDefault(docId, null);
    }

    /**
     * 写到二进制文件
     *
     * @param out :输出流对象
     */
    @Override
    public void writeObject(ObjectOutputStream out) {
        if(out == null){
            return;
        }
        try{
            Set<AbstractTerm> terms = getDictionary();
            out.writeObject(terms.size());
            for(AbstractTerm term : terms){
                term.writeObject(out);
                termToPostingListMapping.get(term).writeObject(out);
            }
            out.writeObject(docIdToDocPathMapping.size());
            docIdToDocPathMapping.forEach((k,v)->{
                try {
                    out.writeObject(k);
                    out.writeObject(v);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            });
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    /**
     * 从二进制文件读
     *
     * @param in ：输入流对象
     */
    @Override
    public void readObject(ObjectInputStream in) {
        if(in == null){
            return;
        }
        try{
            termToPostingListMapping.clear();
            int size =(int) in.readObject();
            for(int i=0;i<size ;i++){
                AbstractTerm t = new Term();
                t.readObject(in);
                AbstractPostingList pl = new PostingList();
                pl.readObject(in);
                termToPostingListMapping.put(t,pl);
            }
            docIdToDocPathMapping.clear();
            size = (int) in.readObject();
            for(int i=0;i<size;i++){
                Integer docId = (Integer) in.readObject();
                String docPath = (String) in.readObject();
                docIdToDocPathMapping.put(docId,docPath);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
    }
}
