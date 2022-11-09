cls

$location = "C:\temp\Autogen\"

$toa = @('DT','TOD','TIME','DATE','STRING','BOOL','BYTE','DINT','WORD','DWORD','LWORD','LREAL','INT','LINT','REAL','SINT','UDINT','UINT','ULINT','USINT')
$toa = $toa | sort
For ($i=0; $i -lt $toa.Length; $i++) {
    $from = $toa[$i]

$dir = $from + "_TO_"
$savedir = $location + $dir + "\"

New-Item -Path $location -Name $dir -ItemType "directory"

For ($j=0; $j -lt $toa.Length; $j++) {
    $to = $toa[$j]

$functionName = 
"Convert_"+$from+"_TO_"+$to

if ($from -eq $to) { # same value

$dec = 
"FUNCTION Convert_"+$from+"_TO_"+$to+" : Hresult
VAR_INPUT
	in : "+$from+";
	out : REFERENCE TO "+$to+";
END_VAR"
$body =
"out := in;"

} else { # different values

$dec = 
"FUNCTION Convert_"+$from+"_TO_"+$to+" : Hresult
VAR_INPUT
	in : "+$from+";
	out : REFERENCE TO "+$to+";
END_VAR
VAR
	converted : "+$to+";
END_VAR
VAR CONSTANT
	INCOMPATIBLE : HRESULT := 16#9811070E;
END_VAR"
$body =
"converted := "+$from+"_TO_"+$to+"(in);

IF ("+$to+"_TO_"+$from+"(converted) <> in) THEN
	Convert_"+$from+"_TO_"+$to+" := INCOMPATIBLE;
	RETURN;
END_IF

out := converted;"

} # end of else

$guid = New-Guid
$xml = 
"<?xml version=`"1.0`" encoding=`"utf-8`"?>
<TcPlcObject Version=`"1.1.0.1`" ProductVersion=`"3.1.4024.12`">
  <POU Name=`"Convert_"+$from+"_TO_"+$to+"`" Id=`"{"+$guid+"}`" SpecialFunc=`"None`">
    <Declaration><![CDATA["+$dec+"]]></Declaration>
    <Implementation>
      <ST><![CDATA["+$body+"]]></ST>
    </Implementation>
  </POU>
</TcPlcObject>
"

#write-host('* ' + $functionName + '(in, out)')

Out-File -FilePath "$savedir$functionName.TcPOU" -encoding utf8 -InputObject $xml

} # end of to loop
} # end of from loop