<%
	function anti_inje(valor)
	
    	valor = replace(valor, chr(39) , "''")
    	valor = replace(valor, chr(34) , "&quot;")	
	
		inje  = array ( "select" , "update", "from", "use", "where", "delete", "drop", "database", "insert", ";", "--", "xp_", "<", "/", "*", "'", ">", "&" )
			for i = 0 to uBound(inje)
				valor = replace(valor,inje(i) ,"")
			next
	
		anti_inje = valor


	end function
	
	function ap(valor)
		
    	valor = replace(valor, "''",chr(39))
		ap = valor
					
	end function
	
	function tira_acentos()
	
		palavra = Lcase("aáàãâäeéèêëiíìîïoóòõôöuúùûü")
		acentos = "aáàãâäeéèêëiíìîïoóòõôöuúùûü"
		
		nvoltas = len(acentos)
		for voltas = 1 to nvoltas step 1
			select case voltas
				case 1,2,3,4,5,6
					str = "a"
				case 7,8,9,10,11
					str = "e"
				case 12,13,14,15,16
					str = "i"
				case 17,18,19,20,21,22
					str = "o"
				case 23,24,25,26,27
					str = "u"
			end select
			palavra = replace(palavra,right(left(acentos,voltas),1),str)
		next
	
		tira_acentos=palavra

	end function
		
	function nl2br(valor)
	
		valor = replace(valor,vbNewline,"<br />")
		nl2br = valor
		
	end function
	
%>	
