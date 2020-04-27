package hust.cs.javacourse.search.index.impl;

import hust.cs.javacourse.search.index.AbstractTerm;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

public class Term extends AbstractTerm {

    private static final long serialVersionUID = 1L;
    public  Term(){
    }
    public  Term(String content){
        this.content = content;
    }
    @Override
    public boolean equals(Object obj) {
        if(obj ==  null){
            return  false;
        }
        if(obj instanceof AbstractTerm){
            AbstractTerm t = (AbstractTerm) obj;
            return t.getContent().equals(this.getContent());
        }
        return false ;
    }

    @Override
    public int hashCode() {
        return this.getContent().hashCode();
    }
    
    @Override
    public String toString() {
        return this.content;
    }

    @Override
    public String getContent() {
        return this.content;
    }

    @Override
    public void setContent(String content) {
        this.content = content;
    }

    @Override
    public int compareTo(AbstractTerm o) {
        return this.content.compareTo(o.getContent());
    }

    @Override
    public void writeObject(ObjectOutputStream out){
        try{
            out.writeObject(this.content);
        }catch(IOException e){
            e.printStackTrace();
        }
    }

    @Override
    public void readObject(ObjectInputStream in) {
        try{
            content = (String) in.readObject();
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
