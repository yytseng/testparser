%{
void yyerror(const char *s);
char testbuf[256];
%}

%union {
 double nr3;   /*double float*/
 int    nr1;   /*integer value*/
 int    cmd;   /*command value*/
 char   *text; /*text string buffer*/
}
// define all tokens for IEEE488.2 mandatory commands.
%token <cmd> IDN CLS RST RCL SAV

// white space accroading to the SCPI standard, just ignore it
%token SPACE "[\0x00-\0x09\0x0b-\0x20\0x1a]+" << skip(); >>

// define tokens for all SCPI commands
// start with the top level
// The actual commands implemented depends on the instrument
%token SENSe    "(SENS) | (SENSE)"
%token TRIGger  "(TRIG) | (TRIGGER)"
%token INIT     "INIT"

// then the sublevel tokens
// typical trigger options
%token LINE     "LINE"
%token IMM      "(IMM) | (IMMediate)"
%token BUS      "BUS"

%token VOLTage  "(VOLT) | (VOLTAGE)"
%token DC       "DC"
%token COUNt    "(COUN) | (COUNT)"
%token SOURce   "(SOUR) | (SOURCE)"

// and finally, punctuation
%token LINK     ";:"
%token COLON    ":"
%token SEMI     ";"

%token CTERM    "[\n]"
%token EOF      "@"

// a number
#NUM

%token
%%
module:
    (linked_command CTERM )* EOF
        ;

linked_command:
    command (LINK command )*
        ;

command:
    status_command
    | sense_command
    | trigger_command
    ;

status_command:
    CLS <<
    | RST <<
    | INIT <<
    ;

sense_command:
    SOURce COLON sense_sub (SEMI sense_sub)*
    ;

sense_sub:
    VOLT DC <<
    ;

trigger_command:
    TRIGger COLON trigger_sub (SEMI trigger_sub)*
    l

trigger_sub:
    SOURce
    (
    LINE <<
    |IMM <<
    |BUS <<
    )
    | COUNT num >> [x] <<
    ;

num > [int n]:
    ii:NUM << $n = atoi($ii.getText()); >>
    ;

%%
void yyerror(const char *s)
{
}
int main()
{
        yyparse();
        return 0;
}
