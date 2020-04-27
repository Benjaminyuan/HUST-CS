package hust.cs.javacourse.search.index.impl;

import hust.cs.javacourse.search.index.AbstractDocument;
import hust.cs.javacourse.search.index.AbstractDocumentBuilder;
import hust.cs.javacourse.search.parse.AbstractTermTupleStream;
import hust.cs.javacourse.search.parse.impl.StopWordTermTupleFilter;
import hust.cs.javacourse.search.parse.impl.TermTupleScanner;
import hust.cs.javacourse.search.index.AbstractTermTuple;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;

public class DocumentBuilder extends AbstractDocumentBuilder {
    @Override
    public AbstractDocument build(int docId, String docPath, AbstractTermTupleStream termTupleStream) {
        AbstractDocument d = new Document();
        d.setDocId(docId);
        d.setDocPath(docPath);
        if(termTupleStream == null){
            return d;
        }

        AbstractTermTuple t = termTupleStream.next();
        while (t != null){
            d.addTuple(t);
            t = termTupleStream.next();
        }
        return d;
    }
    @Override
    public AbstractDocument build(int docId, String docPath, File file) {
        if(file == null || !file.exists()){
            return new Document();
        }
        AbstractDocument d = null ;
        try{
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(new FileInputStream(file)));

            AbstractTermTupleStream stream = new StopWordTermTupleFilter(new TermTupleScanner(bufferedReader));
            d = build(docId,docPath,stream);
        }catch(Exception e){
            e.printStackTrace();
        }
        return d;
    }
}
