{
	fpc -S2 -O3 pastest.pas

	"Performance ist nicht das Problem, es läuft ja nachher beides auf der
	selben Hardware." -- Hans-Peter Diettrich in d.s.e.
	<gs5ac5F1uscU1@mid.individual.net> on 2019-08-21

	"> Mach doch mal Messungen. Gerne auch Pascal vs. C.
	Das würde ich *Dir* einmal empfehlen, mir ist der kaum meßbare Unterschied bekannt."
	-- Hans-Peter Diettrich in d.s.e.
	<gs5h9jF3eqlU1@mid.individual.net> on 2019-08-21

	"Man kann jeden Benchmark fälschen. Wer damit was anderes als Compiler der
	gleichen Programmiersprache vegleicht, hat spezielle Eigeninteressen."
	-- Hans-Peter Diettrich in d.s.e.
	<gs5rb8F5imlU5@mid.individual.net> on 2019-08-21

	"Bei meinem Nachbau des ACK war Delphi ca. 5% langsamer als C."
	-- Hans-Peter Diettrich in d.s.e.
	<gs5rb8F5imlU5@mid.individual.net> on 2019-08-21

	"Wenn Du meinst, daß Pascal Code mehr als 10% langsamer ist als C Code, dann
	mach doch selber einen Benchmark, damit ich Deinen Quelltext zerpflücken kann.
	Von einem C Programmierer erwarte ich keinen ordentlichen (vergleichbaren)
	FORTH oder Pascal Code." -- Hans-Peter Diettrich in d.s.e.
	<gs5vg7F6djfU2@mid.individual.net> on 2019-08-22
}
program RC4Test;

type
	RC4Context = record
		S : array[0..255] of byte;
		i, j : byte;
	end;

procedure RC4Init(Out ctx : RC4Context; var key : array of byte);
var
	i, j, tmp : byte;
begin
	for i := 0 to 255 do begin
		ctx.S[i] := i;
	end;

	j := 0;
	for i := 0 to 255 do begin
		j := (j + ctx.S[i] + key[i mod length(key)]);
		tmp := ctx.S[i];
		ctx.S[i] := ctx.S[j];
		ctx.S[j] := tmp;
	end;

	ctx.i := 0;
	ctx.j := 0;
end;

function RC4Next(Out ctx : RC4Context) : byte;
var
	tmp : byte;
begin
	ctx.i := ctx.i + 1;
	ctx.j := ctx.j + ctx.S[ctx.i];

	tmp := ctx.S[ctx.i];
	ctx.S[ctx.i] := ctx.S[ctx.j];
	ctx.S[ctx.j] := tmp;

	RC4Next := ctx.S[(ctx.S[ctx.i] + ctx.S[ctx.j]) mod 256];
end;

var
	context : RC4Context;
	key : array of byte;
	ctr : integer;
begin
	setLength(key, 5);
	key[0] := 97;
	key[1] := 138;
	key[2] := 99;
	key[3] := 210;
	key[4] := 251;

	for ctr := 1 to 10000000 do begin
		RC4Init(context, key);
	end

	{
	RC4Init(context, key);
	for ctr := 1 to 2000000000 do begin
		RC4Next(context);
	end;
	}
end.
