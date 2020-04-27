package hust.cs.javacourse.search.parse.impl;

import hust.cs.javacourse.search.index.AbstractTermTuple;
import hust.cs.javacourse.search.parse.AbstractTermTupleFilter;
import hust.cs.javacourse.search.parse.AbstractTermTupleStream;
import hust.cs.javacourse.search.util.Config;
import hust.cs.javacourse.search.util.StopWords;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class PatternTermTupleFilter  extends AbstractTermTupleFilter {
    private Pattern pattern = Pattern.compile(Config.TERM_FILTER_PATTERN);

    /**
     * 构造函数
     *
     * @param input ：Filter的输入，类型为AbstractTermTupleStream
     */
    public PatternTermTupleFilter(AbstractTermTupleStream input) {
        super(input);
    }
    public void setPattern(Pattern p){
        this.pattern = p;
    }

    @Override
    public AbstractTermTuple next() {
        AbstractTermTuple tuple = input.next();
        while(tuple != null && !pattern.matcher(tuple.term.getContent()).matches()){
            tuple = input.next();
        }
        return tuple;
    }

}