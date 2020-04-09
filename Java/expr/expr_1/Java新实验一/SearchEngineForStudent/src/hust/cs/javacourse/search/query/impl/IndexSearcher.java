package hust.cs.javacourse.search.query.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import hust.cs.javacourse.search.index.AbstractPosting;
import hust.cs.javacourse.search.index.AbstractPostingList;
import hust.cs.javacourse.search.index.AbstractTerm;
import hust.cs.javacourse.search.query.AbstractHit;
import hust.cs.javacourse.search.query.AbstractIndexSearcher;
import hust.cs.javacourse.search.query.Sort;

public class IndexSearcher extends AbstractIndexSearcher {

    @Override
    public void open(String indexFile) {
        index.load(new File(indexFile));
    }

    @Override
    public AbstractHit[] search(AbstractTerm queryTerm, Sort sorter) {
        AbstractPostingList pl = index.search(queryTerm);
        AbstractHit[] res = new Hit[pl.size()];
        for (int i = 0; i < pl.size(); i++) {
            AbstractPosting p = pl.get(i);
            Map<AbstractTerm, AbstractPosting> t = new HashMap<>();
            t.put(queryTerm, p);
            res[i] = new Hit(p.getDocId(), index.getDocName(p.getDocId()), t);
            sorter.score(res[i]);
        }
        return res;
    }

    @Override
    public AbstractHit[] search(AbstractTerm queryTerm1, AbstractTerm queryTerm2, Sort sorter,
            LogicalCombination combine) {
        List<AbstractHit> res = new ArrayList<>();
        AbstractPostingList pl1 = index.search(queryTerm1);
        AbstractPostingList pl2 = index.search(queryTerm2);
        switch (combine) {
            case ADN:
                for (int i = 0; i < pl1.size(); i++) {
                    for (int j = 0; j < pl2.size(); j++) {

                        AbstractPosting p1 = pl1.get(i);
                        AbstractPosting p2 = pl2.get(j);
                        Map<AbstractTerm, AbstractPosting> t = new HashMap<>();

                        if (p1.getDocId() == p2.getDocId()) {
                            t.put(queryTerm1, p1);
                            t.put(queryTerm2, p2);
                            AbstractHit hit = new Hit(p1.getDocId(), index.getDocName(p1.getDocId()), t);
                            sorter.score(hit);
                            res.add(hit);
                        }
                    }
                }
                break;
            case OR:
                Set<Integer> s = new HashSet<>();
                for (int i = 0; i < pl1.size(); i++) {
                    AbstractPosting p1 = pl1.get(i);
                    AbstractPosting p2 = pl2.get(pl2.indexOf(p1.getDocId()));
                    Map<AbstractTerm, AbstractPosting> t = new HashMap<>();
                    t.put(queryTerm1, p1);
                    if (p2 != null) {
                        t.put(queryTerm2, p2);
                        // 便于pl2遍历时筛选;
                        s.add(p1.getDocId());
                    }
                    AbstractHit hit = new Hit(p1.getDocId(), index.getDocName(p1.getDocId()), t);
                    sorter.score(hit);
                    res.add(hit);

                }
                for (int i = 0; i < pl2.size(); i++) {
                    AbstractPosting p2 = pl2.get(i);
                    //判断是否被添加了
                    if (s.contains(p2.getDocId())) {
                        continue;
                    }
                    Map<AbstractTerm, AbstractPosting> t = new HashMap<>();
                    t.put(queryTerm2, p2);
                    AbstractHit hit = new Hit(p2.getDocId(), index.getDocName(p2.getDocId()), t);
                    sorter.score(hit);
                    res.add(hit);

                }
                break;
        }
        return (AbstractHit[]) res.toArray();
    }

}