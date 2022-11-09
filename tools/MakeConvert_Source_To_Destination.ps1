cls

$savedir = "C:\temp\Autogen\"

$toa = @('DT','TOD','TIME','DATE','STRING','BOOL','BYTE','DINT','WORD','DWORD','LWORD','LREAL','INT','LINT','REAL','SINT','UDINT','UINT','ULINT','USINT')

$toa = $toa | sort

$functionName = 
"Convert_Source_TO_Destination"

$dec = 
"FUNCTION Convert_Source_TO_Destination : Hresult
VAR_INPUT
	in :  ANY;
	out : ANY;
END_VAR
VAR
	convertResult : HRESULT := INCOMPATIBLE;
END_VAR
VAR CONSTANT
	INCOMPATIBLE : HRESULT := 16#9811070E;
END_VAR"

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
	
		convertResult := Convert_"+$to+"_To_Destination(in, out);

"	
}

$body3 = "END_CASE

Convert_Source_TO_Destination  := convertResult;"

$body = $body1 + $body2 + $body3

$guid = New-Guid
$xml = 
"<?xml version=`"1.0`" encoding=`"utf-8`"?>
<TcPlcObject Version=`"1.1.0.1`" ProductVersion=`"3.1.4024.12`">
  <POU Name=`"Convert_Source_TO_Destination`" Id=`"{"+$guid+"}`" SpecialFunc=`"None`">
    <Declaration><![CDATA["+$dec+"]]></Declaration>
    <Implementation>
      <ST><![CDATA["+$body+"]]></ST>
    </Implementation>
  </POU>
</TcPlcObject>
"

#write-host($body)

Out-File -FilePath "$savedir$functionName.TcPOU" -encoding utf8 -InputObject $xml