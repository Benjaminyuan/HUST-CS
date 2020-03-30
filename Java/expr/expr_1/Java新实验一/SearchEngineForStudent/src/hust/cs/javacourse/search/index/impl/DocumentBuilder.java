package hust.cs.javacourse.search.index.impl;

import hust.cs.javacourse.search.index.AbstractDocument;
import hust.cs.javacourse.search.index.AbstractDocumentBuilder;
import hust.cs.javacourse.search.parse.AbstractTermTupleStream;
import hust.cs.javacourse.search.index.AbstractTermTuple;

import java.io.File;

public class DocumentBuilder extends AbstractDocumentBuilder {
    @Override
    public AbstractDocument build(int docId, String docPath, AbstractTermTupleStream termTupleStream) {
        AbstractDocument d = new Document();
        d.setDocId(docId);
        d.setDocPath(docPath);
        AbstractTermTuple t = termTupleStream.next();
        while (t != null){
            d.addTuple(t);
            t = termTupleStream.next();
        }
        return d;
    }

    @Override
    public AbstractDocument build(int docId, String docPath, File file) {
        return null;
    }
}
