<?php
/*
USAGE:
php assebler.php file
*/
echo "Customized MIPS Assebler\nEHSAN MONTAHAIE\n902171028\n";
if(!isset($argv[1]))
	die("\nUSAGE:\nphp $argv[0] FILE\nnote:use 'b' for binary and 'x' for hex value");
	
$insop=array('add'=>'000000','sub'=>'000000','lw'=>'100011','sw'=>'101011','beq'=>'000100','bne'=>'000101','addi'=>'001000');
$func=array('add'=>'100000','sub'=>'100010');

if(file_exists($argv[1])){
	$inp=file($argv[1]);
	echo "\nInput code:\n";
	print_r($inp);
	foreach($inp as $index => $cinp){	//find labels
		$cinp=str_replace("\r",'',$cinp);
		$cinp=str_replace("\n",'',$cinp);
		$cinp=str_replace("\t",'',$cinp);
		$cinp=str_replace(' ','',$cinp);
		$rinp=explode(':',$cinp);
		if (sizeof($rinp)>1)
			$labels[$rinp[0]]=$index;
	}
	
	echo "\nFounded labels:\n";
	print_r($labels);
	
	$res='';
	foreach($inp as $index => $cinp){
		$cinp=str_replace("\r",'',$cinp);
		$cinp=str_replace("\n",'',$cinp);
		$cinp=str_replace("\t",' ',$cinp);
		$cinp=str_replace(',',' ',$cinp);
		$cinp=str_replace('(',' ',$cinp);
		$cinp=str_replace(')','',$cinp);
		while(strpos($cinp,'  ')!==false)
			$cinp=str_replace('  ',' ',$cinp);
		
		$rinp=explode(':',$cinp);
		if (sizeof($rinp)>1)
			$rinp[0]=$rinp[1];
		if($rinp[0][0]==' ')
			$rinp[0]=substr($rinp[0],1);
		$inspart=explode(' ',$rinp[0]);
		
		if($inspart[0]=='addi')
			$res.='"'.$insop[$inspart[0]].reg2code($inspart[2]).reg2code($inspart[1]).val2bin($inspart[3]);
		else if($inspart[0]=='lw')
			$res.='"'.$insop[$inspart[0]].reg2code($inspart[3]).reg2code($inspart[1]).val2bin($inspart[2]);
		else if($insop[$inspart[0]]=='00000')	//R types
			$res.='"'.$insop[$inspart[0]].reg2code($inspart[2]).reg2code($inspart[3]).reg2code($inspart[1])."00000".$func[$inspart[0]];
		else if($inspart[0]=='bne'){
			if(!isset($labels[$inspart[3]]))
				die("\nLABEL NOT FOUND!!");
			$res.='"'.$insop[$inspart[0]].reg2code($inspart[2]).reg2code($inspart[1]).val2bin($labels[$inspart[3]]-$index-1);
		}
		else
			die("\nUNKNOWN INSTRUCT ".$index.':'.$inspart[0]."\n");
			
		$res.="\",\t--";
		foreach($inspart as $cmins)
			$res.=$cmins."\t";
		$res.="\n";
	}
	//echo $res;
	echo "\nRESULT:\n\nsignal tmp_ram: ram_type :=(\t\t--Ehsan Montahaie(902171028) ,Mips Assembler\n".$res."others => x\"00000000\");\n";
		
}
else
	die("\nFILE NOT EXISTS");
	
function reg2code($inp){
	$inp=str_replace('$','',$inp);
	if($inp[0]=='s')
		return str_pad(substr(decbin(16+$inp[1]),-5,5),5,'0', STR_PAD_LEFT);
	return '00000';
}

function val2bin($inp){
	$pad='0';
	if($inp[0]=='b')
		$res=str_replace('b','',$inp);
	else if($inp[0]=='x')
		$res=decbin(hexdec(str_replace('x','',$inp)));
	else{
		$res=decbin($inp);
		if($inp<0)
			$pad='1';
	}
	return str_pad(substr($res,-16,16),16,$pad,STR_PAD_LEFT);
}
?>