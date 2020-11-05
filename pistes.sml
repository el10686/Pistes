fun pistes file = 
	let 
		(* A function to read an integer from specified input. *)
  		fun readInt input =
		 Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

        	(* Open input file. *)
        	val inStream = TextIO.openIn file

        	(* Read an integer (number of pistes) and consume newline. *)
        	val m = readInt inStream
        	val _ = TextIO.inputLine inStream
		
		val seqNum = 0

		fun readInts 0 = []	
		|   readInts n = 
			let
				val temp = readInt inStream
			in
				temp::(readInts (n-1))
			end
		
		fun readLine seqNum = 
			let
				val numkeysNeeded = readInt inStream
				val numkeysGained = readInt inStream
				val stars = readInt inStream
				val keysNeeded = readInts numkeysNeeded
				val keysGained = readInts numkeysGained
			in
				(seqNum,numkeysNeeded,numkeysGained,stars,keysNeeded,keysGained)
			end

		fun totalRead 0 acc = []
		|   totalRead m acc = 
			(readLine acc)::(totalRead (m-1) (acc+1))
	
	
		val arxeio = totalRead (m+1) 0 
		val q = Queue.mkQueue () : (int * int * int list * int list) Queue.queue
		
		val a = hd arxeio
		val b : int= #4a
		val c : int list= #6a
		val d : int list= [0]
		val e = Queue.enqueue (q, (0, b, c, d))
   				
	
		fun checkIfExists [] check = false 
		|   checkIfExists (hd::tl) check = 
			if hd = (check:int) then true
			else checkIfExists tl check
		
		fun valid ((elem:int), []) = ([], false)
		 |  valid (elem, l) =
			if elem = hd l then (tl l, true)
		        else 	
	                let 
				val (a,b) = valid(elem, tl l)
			in
				((hd l)::a,b)
	       		end

		fun checkEnter [] [] = true 
		  | checkEnter [] l2 = false
		  | checkEnter l1 [] = true
		  | checkEnter l1 l2 = 
			let
				val (l, flag) = valid ((hd l2), l1) 
			in 
				if flag=false then false
				else checkEnter l (tl l2) 
			end
		(*fun valid ((elem:int), []) = ([], false)
		 |  valid (elem, l) =
        		let
                		val (a,b) = valid(elem, tl l)
       			 in
                		if elem = hd l then (tl l, true)
                		else ((hd l)::a,b)
        		end

		fun checkEnter [] [] = true 
		  | checkEnter [] l2 = false
		  | checkEnter l1 [] = true
		  | checkEnter l1 l2 = 
			let
				val (l, flag) = valid ((hd l1), l2) 
			in 
				if flag=false then false
				else checkEnter (tl l1) l
			end*)

		(*fun checkForAll target [] = true
		|  checkForAll target (hd::tl) = 
			if not (checkIfExists target hd) then false
			else checkForAll target tl*)
		
		(*fun delete (item, list) = List.filter(fn x => x <> item) list*)
		fun delete ((elem:int), []) = []
		 |  delete (elem, l) = 
			if elem = hd l then tl l 
			else (hd l)::delete(elem, tl l)  

		fun deleteAll targetlist [] = targetlist
		| deleteAll targetlist (hd::tl) =
			deleteAll (delete (hd,targetlist)) tl 
 
		fun createNewNode seqNumPrevious starsPrevious keysPrevious pistsPrevious (a,b,c,d,e,f) =
			let
				val finalKeys = (deleteAll keysPrevious e) @ f
				val finalpists = pistsPrevious@[a]
				val finalStars = starsPrevious + d
			in
				Queue.enqueue (q, (a,finalStars,finalKeys,finalpists)); finalStars
			end
	
			
		fun iteratePists seqNumChecked starsChecked keysChecked pistsChecked [] maxStars = maxStars
		|   iteratePists seqNumChecked starsChecked keysChecked pistsChecked (hd::tl) maxStars= 
			if checkIfExists pistsChecked (#1hd) then iteratePists seqNumChecked starsChecked keysChecked pistsChecked tl maxStars
			else if List.length keysChecked < (#2hd) then iteratePists seqNumChecked starsChecked keysChecked pistsChecked tl maxStars
			else if checkEnter keysChecked (#5hd) then 
				let
					val temp = createNewNode seqNumChecked starsChecked keysChecked pistsChecked hd
				in
					if temp > maxStars then  iteratePists seqNumChecked starsChecked keysChecked pistsChecked tl temp
					else iteratePists seqNumChecked starsChecked keysChecked pistsChecked tl maxStars
				end
			else iteratePists seqNumChecked starsChecked keysChecked pistsChecked tl maxStars
						 
		(* fun iterateQueue *)
		fun iterateQueue stars 1 = stars
		|   iterateQueue stars flag = 
			let
				val dq = Queue.dequeue q
				val seqNum = #1dq
				val starss = #2dq
				val keys = #3dq
				val pists = #4dq

				val tempp = iteratePists seqNum starss keys pists arxeio starss 

				in 
			
					if tempp > stars then 
						if (Queue.isEmpty q) then iterateQueue tempp 1
						else iterateQueue tempp flag  
					else 
						if (Queue.isEmpty q) then iterateQueue stars 1
						else iterateQueue stars flag
				
			end

		
				 
	in
		print(Int.toString (iterateQueue 0 0)); print("\n")
	end
