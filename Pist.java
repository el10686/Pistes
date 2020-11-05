/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
//package pistes;
import java.util.*;

/**
 *
 * @author goji
 */
public class Pist {
    
    public int seqNum;
    public int stars;
    public int numOfKeysNeeded;
    public int numOfKeysGained;
    public ArrayList<Integer> keysNeeded;
    public ArrayList<Integer> keysGained;
    
    public Pist()
    {
           keysNeeded = new ArrayList<>();
           keysGained = new ArrayList<>();
    }
}
