package hust.cs.javacourse.search.parse.impl;

import hust.cs.javacourse.search.index.AbstractTermTuple;
import hust.cs.javacourse.search.parse.AbstractTermTupleFilter;
import hust.cs.javacourse.search.parse.AbstractTermTupleStream;
import hust.cs.javacourse.search.util.Config;
import hust.cs.javacourse.search.util.StopWords;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public class LengthTermTupleFilter extends AbstractTermTupleFilter {

    /**
     * 构造函数
     *
     * @param input ：Filter的输入，类型为AbstractTermTupleStream
     */
    public LengthTermTupleFilter(AbstractTermTupleStream input) {
        super(input);
    }

    @Override
    public AbstractTermTuple next() {
        AbstractTermTuple tuple = null;
        tuple = input.next();
        while(tuple != null && ( tuple.term.getContent().length()  < Config.TERM_FILTER_MINLENGTH  ||
                tuple.term.getContent().length() > Config.TERM_FILTER_MAXLENGTH)){
            tuple = input.next();
        }
        return tuple;
    }

}