/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
//package pistes;

/**
 *
 * @author goji
 */

import java.io.*;
import java.util.*;

public class Pistes {

    /**
     * @param args the command line arguments
     * @throws java.io.IOException
     */
    public static void main(String[] args) throws IOException {
            Scanner sc = new Scanner(new File(args[0]));
            Pist[] availablePists;
            Pist temp;
            String line;
            int N, maxStars=-1;
            N = sc.nextInt();
            availablePists = new Pist[N+1];
            int pistCnt = 0;
            boolean canEnter = true;
            boolean first = true;
            
            while (sc.hasNext())
            {
                temp = new Pist();
                temp.seqNum = pistCnt;
                temp.numOfKeysNeeded = sc.nextInt();
                temp.numOfKeysGained = sc.nextInt();
                temp.stars = sc.nextInt();
                for(int tmp = 0; tmp < temp.numOfKeysNeeded; tmp++)
                {
                     temp.keysNeeded.add(sc.nextInt());
                }
                for(int tmp = 0; tmp < temp.numOfKeysGained; tmp++)
                {
                    temp.keysGained.add(sc.nextInt());
                }
                availablePists[pistCnt] = temp;
                pistCnt++;
            }
            
            Queue<Node> Q = new Queue();
            Node tempNode = new Node();
            tempNode.seqNum = availablePists[0].seqNum;
            tempNode.stars = availablePists[0].stars;
            
            for (int j=0; j < availablePists[0].numOfKeysGained;j++)
            {
              tempNode.keys.add(availablePists[0].keysGained.get(j));
            }
            
            tempNode.pistes.add(0);
            maxStars = tempNode.stars;
            Q.enqueue(tempNode);
            Node mytempNode;
            boolean isAlready = true;
            Iterator<Node> a;
            
            while (!Q.isEmpty())
            {
                mytempNode = Q.dequeue();
                
                for(int i=0; i < pistCnt;i++) //na to ksanatsekarw
                {   
                    tempNode = new Node();
                    tempNode.seqNum = Integer.valueOf(mytempNode.seqNum);
                    tempNode.stars = Integer.valueOf(mytempNode.stars);
                    
                    for (int j=0; j < mytempNode.keys.size();j++)
                    {
                        tempNode.keys.add(mytempNode.keys.get(j));
                    }   
                    for (int j=0; j < mytempNode.pistes.size();j++)
                    {
                        tempNode.pistes.add(mytempNode.pistes.get(j));
                    }

                    if (tempNode.pistes.contains(i))  //auto simainei oti exw idi mpei stin pista pou paw na tsekarw
                    {
                        continue;
                    }
                    
                    if (tempNode.keys.size() < availablePists[i].numOfKeysNeeded) //an exw ligotera kleidia apo auta pou xreiazomai, poulo
                    {
                        continue;
                    }
                                        
                    for (int j=0;j < availablePists[i].numOfKeysNeeded;j++)
                    {
                        if (!tempNode.keys.contains(availablePists[i].keysNeeded.get(j)))
                            canEnter = false;
                    }
                    
                    ArrayList<Integer> keys = new ArrayList<>();
                    
                    for (int g = 0; g < tempNode.keys.size(); g++)
                    {
                        keys.add(tempNode.keys.get(g));
                    }
                    
                    for (int j=0;j<=availablePists[i].numOfKeysNeeded-1;j++)
                        {
                       
                            if (!keys.remove(Integer.valueOf(availablePists[i].keysNeeded.get(j))))
                                canEnter = false;
                        }

                    if (canEnter == true)
                    {
                        for (int j=0;j<=availablePists[i].numOfKeysNeeded-1;j++)
                        {
                            tempNode.keys.remove(Integer.valueOf(availablePists[i].keysNeeded.get(j)));
                        }
                        
                        for (int k=0;k<=availablePists[i].numOfKeysGained-1;k++)
                        {
                            tempNode.keys.add(availablePists[i].keysGained.get(k));
                        }
                        
                        
                            
                        tempNode.pistes.add(i);
                        tempNode.seqNum = i;
                        tempNode.stars += availablePists[i].stars;
                        if (tempNode.stars > maxStars)
                        {
                            maxStars = tempNode.stars;
                           
                        }
                        
                        a = Q.iterator();
                        Node testNode;
                        isAlready=false;
                        
                        for(;;)
                        {
                            try
                            {
                                testNode = a.next();            
                            }
                            catch (NoSuchElementException e)
                            {
                                break;
                            }
                            
                            first = false;
                            
                            if ((tempNode.seqNum != testNode.seqNum) || ((tempNode.seqNum == testNode.seqNum) && (tempNode.pistes.size() != testNode.pistes.size())))
                                continue;

                            int same=0;

                            for (int l=0;l < tempNode.pistes.size();l++)
                            {                                    
                                    if ((testNode.pistes.contains(tempNode.pistes.get(l))))
                                    {
                                        same++;
                                    }
                            }
                            
                            if (same == tempNode.pistes.size())
                            {
                                        isAlready=true;
                                        break;
                            }
                        }
                        
                        if (isAlready == false)
                        {
                            Q.enqueue(tempNode);
                        }                               
                    }
                    canEnter = true;
                }                   
            }
            System.out.println(maxStars);   
    }
}            
