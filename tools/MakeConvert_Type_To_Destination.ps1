cls

$location = "C:\temp\Autogen\"

$toa = @('DT','TOD','TIME','DATE','STRING','BOOL','BYTE','DINT','WORD','DWORD','LWORD','LREAL','INT','LINT','REAL','SINT','UDINT','UINT','ULINT','USINT')

$toa = $toa | sort

For ($i=0; $i -lt $toa.Length; $i++) {
    $from = $toa[$i]

$dir = $from + "_TO_"
$savedir = $location + $dir + "\"

New-Item -Path $location -Name $dir -ItemType "directory"


$functionName = 
"Convert_"+$from+"_TO_"

$dec = 
"FUNCTION Convert_"+$from+"_TO_"+$to+" : Hresult
VAR_INPUT
	in : "+$from+";
	out : REFERENCE TO "+$to+";
END_VAR"
$body =
"out := in;"

$decp1 = 
"FUNCTION Convert_"+$from+"_TO_Destination : Hresult
VAR_INPUT
	in : "+$from+";
	out : ANY;
END_VAR
VAR
	convertResult : HRESULT := INCOMPATIBLE;
	convertAddress : PVOID;
"

$decp2 = ""

For ($j=0; $j -lt $toa.Length; $j++) {
    $to = $toa[$j]

$decp2 = $decp2 +  "	_"+$to+" : "+$to+";
"
}

$decp3 =
"END_VAR
VAR CONSTANT
	INCOMPATIBLE : HRESULT := 16#9811070E;
END_VAR"

$dec = $decp1 + $decp2 + $decp3

$body1 = "CASE out.TypeClass OF
	
"

$body2 = ""

For ($j=0; $j -lt $toa.Length; $j++) {
    $to = $toa[$j]

$type = $to

if ($type -eq 'tod') {
$type = 'TIMEOFDAY'
}

if ($type -eq 'dt') {
$type = 'DATEANDTIME'
}


$body2 = $body2 +  "	__SYSTEM.TYPE_CLASS.TYPE_"+$type+":
	
		convertResult := Convert_"+$from+"_TO_"+$to+"(in, _"+$to+");
		IF SUCCEEDED(convertResult) THEN
			convertAddress := ADR(_"+$to+");
		END_IF

"	
}

$body3 = "END_CASE

IF SUCCEEDED(convertResult) THEN
	memcpy(out.pValue,convertAddress,DINT_TO_UDINT(out.diSize));
END_IF

Convert_"+$from+"_TO_Destination := convertResult;"

$body = $body1 + $body2 + $body3

$guid = New-Guid
$xml = 
"<?xml version=`"1.0`" encoding=`"utf-8`"?>
<TcPlcObject Version=`"1.1.0.1`" ProductVersion=`"3.1.4024.12`">
  <POU Name=`"Convert_"+$from+"_TO_`" Id=`"{"+$guid+"}`" SpecialFunc=`"None`">
    <Declaration><![CDATA["+$dec+"]]></Declaration>
    <Implementation>
      <ST><![CDATA["+$body+"]]></ST>
    </Implementation>
  </POU>
</TcPlcObject>
"

write-host('* ' + $functionName + '(in, out)')

Out-File -FilePath "$savedir$functionName.TcPOU" -encoding utf8 -InputObject $xml


} # end of from loop