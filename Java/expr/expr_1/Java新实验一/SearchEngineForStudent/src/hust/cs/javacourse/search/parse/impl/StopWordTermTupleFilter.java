package hust.cs.javacourse.search.parse.impl;

import hust.cs.javacourse.search.index.AbstractTermTuple;
import hust.cs.javacourse.search.parse.AbstractTermTupleFilter;
import hust.cs.javacourse.search.parse.AbstractTermTupleStream;
import hust.cs.javacourse.search.util.StopWords;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
public class StopWordTermTupleFilter extends AbstractTermTupleFilter {
    private Set<String> stopWords;
    public StopWordTermTupleFilter(AbstractTermTupleStream input) {
        super(input);
        stopWords = new HashSet<>();
        stopWords.addAll(Arrays.asList(StopWords.STOP_WORDS));
    }

    @Override
    public AbstractTermTuple next() {
        AbstractTermTuple tuple = null;
        tuple = input.next();
        while(tuple != null && stopWords.contains(tuple.term.getContent())){
            tuple = input.next();
        }
        return tuple;
    }

}