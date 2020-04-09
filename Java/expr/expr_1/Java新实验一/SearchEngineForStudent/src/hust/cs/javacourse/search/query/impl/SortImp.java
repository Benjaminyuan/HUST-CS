package hust.cs.javacourse.search.query.impl;

import java.util.List;
import java.util.Set;

import hust.cs.javacourse.search.query.AbstractHit;
import hust.cs.javacourse.search.query.Sort;
import hust.cs.javacourse.search.index.AbstractTerm;
public class SortImp implements Sort {

    @Override
    public void sort(List<AbstractHit> hits) {
        hits.sort(
            (o1,o2)-> Double.compare(o1.getScore(),o2.getScore()));
    }

    @Override
    public double score(AbstractHit hit) {
        Set<AbstractTerm> s = hit.getTermPostingMapping().keySet();
        double score = 0.0;
        for(AbstractTerm term :s){
            score += hit.getTermPostingMapping().get(term).getFreq();
        }
        hit.setScore(score);
        return 0;
    }
}