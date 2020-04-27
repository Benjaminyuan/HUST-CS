package hust.cs.javacourse.search.query.impl;

import java.util.HashMap;
import java.util.Map;

import hust.cs.javacourse.search.index.AbstractPosting;
import hust.cs.javacourse.search.index.AbstractTerm;
import hust.cs.javacourse.search.query.AbstractHit;

public class Hit extends AbstractHit {

    public  Hit(int docId, String docPath) {
        super(docId,docPath);
    }
    public Hit(int docId, String docPath, Map<AbstractTerm, AbstractPosting> termPostingMapping){
        super(docId,docPath,termPostingMapping);
    }
    @Override
    public int getDocId() {
        return docId;
    }

    @Override
    public String getDocPath() {
        return docPath;
    }

    @Override
    public String getContent() {
        return content;
    }

    @Override
    public void setContent(String content) {
        this.content = content;
    }

    @Override
    public double getScore() {
        return score;
    }

    @Override
    public void setScore(double score) {
        this.score = score;
    }

    @Override
    public Map<AbstractTerm, AbstractPosting> getTermPostingMapping() {
        // return new HashMap<>(this.termPostingMapping);
        return this.termPostingMapping;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(String.format("docId: %d, docPath: %s, content: %s, score: %.1f\n",
            this.getDocId(),this.getDocPath(),this.getContent(),this.getScore()));
        sb.append("map:\n");
        this.termPostingMapping.forEach((k,v)->{
            sb.append(String.format("key: %s, value: %s", k.toString(),v.toString()));
        });
        return sb.toString();
    }

    @Override
    public int compareTo(AbstractHit o) {
        return Double.compare(score, o.getScore());
    }
    
}