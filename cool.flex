/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%option noyywrap

%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */


/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */

%}

/*
 * Define names for regular expressions here.
 */


KEYWORDS         if|fi|else|class|then|case|esac
SPACES           [\n\r\t]

PRIMITIVE        Object|Int|String
TYPE             {PRIMITIVE}|{NEWTYPE}|{VARIABLE}
NEWTYPE          [ID]:{ANYSPACES}[a-z\t\r\n]*|{PRIMITIVE}
STRING           \"[a-z\t\r\n]*\"
VARIABLE         [a-zA-Z][a-zA-Z0-9]*
DIGIT            [0-9]*
ID               let[ ]{VARIABLE}
ANYSPACES        [ ]*
EOF              <<EOF>>
ATTRIBUTION      <-{ANYSPACES}{DIGIT}
NEWINSTANCE      \(new{ANYSPACES}{VARIABLE}\)
METHOD           [.]{0,1}[a-z_]+\(.*\)
BLOCKSTART       \{
BLOCKEND         \}

%%

 /*
  *  Nested comments
  */

 /*
  *  The multiple-character operators.
  */
{STRING}        { std::cout << "STRING[" << yytext << "]"; }
{ATTRIBUTION}   { std::cout << "ATTRIBUTION[" << yytext << "]"; }
{PRIMITIVE}     { std::cout << "PRIMITIVE[" << yytext << "]"; }
{ID}            { std::cout << "ID[" << yytext << "]"; }
{KEYWORDS}      { std::cout << "KEYWORD[" << yytext << "]"; }
{TYPE}          { std::cout << "TYPE[" << yytext << "]"; }
{NEWTYPE}       { std::cout << "ID:TYPE[" << yytext << "]"; }
{NEWINSTANCE}   { std::cout << "NEWINSTANCE[" << yytext << "]"; }
{METHOD}        { std::cout << "METHOD[" << yytext << "]"; }
{BLOCKSTART}    { std::cout << "STARTBLOCK[" << yytext << "]"; }
{BLOCKEND}      { std::cout << "ENDBLOCK[" << yytext << "]"; }


 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter.
  */

 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */
  
  <STRING>\\.     {
                switch (yytext[1])
                {
                    case 'b': append(string_buf, '\b'); break;
                    case 't': append(string_buf, '\t'); break;
                    case 'n': append(string_buf, '\n'); break;
                    case 'f': append(string_buf, '\f'); break;
                    default: append(string_buf, yytext[1]);
                }
            }


%%
