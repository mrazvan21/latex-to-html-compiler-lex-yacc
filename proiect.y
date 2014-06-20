%{
#include <stdio.h>
#include <ctype.h>
#include <string.h>

int countsection = 1;
char* title;
int istitle = 0;
FILE *html;
%}

%union 
{
  char*	charval;
  int	val;
}

%start statement
%token HSPACE LETTERS OPERATOR SPECCHAR VSPACE LBEGINDOCU LENDDOCU DOCUMENTCLASS ARTICLE PROC LETTER SECTION BOLD ITALIC LBRACE RBRACE TITLE BACKSLBACKSL BACKSL DOLLAR POW
%type <charval> operand
%token <charval> WORD 
%token <charval> LETTERS
%token <charval> OPERATOR
%token <val> INTEGER

%%

statement: documenttype{fprintf(html,"<html> \n"); istitle=1; title=(char *)malloc(255*sizeof(char));}  titletype LBEGINDOCU{fprintf(html,"<body>\n"); if(istitle) fprintf(html,"<h1>%s</h1>\n", title); istitle=0; } mainbody {fprintf(html,"</body>\n"); } LENDDOCU {fprintf(html,"</html> \n"); }
;

documenttype: DOCUMENTCLASS LBRACE typedoc RBRACE
;

typedoc : ARTICLE
		| PROC
		| LETTER
;

titletype: TITLE LBRACE {fprintf(html,"<head> <title> ");} textoption RBRACE {fprintf(html,"</title> </head>\n");}
		 |
;

sectiontype: SECTION LBRACE {fprintf(html,"<h3>"); fprintf(html, "%d. ", countsection); countsection++;} textoption RBRACE {fprintf(html,"</h3>\n"); }
		   |
;

mathoption: DOLLAR {fprintf(html,"<math>\n");} {fprintf(html,"<mrow>\n"); } mathsection {fprintf(html,"</mrow>\n"); } DOLLAR {fprintf(html,"</math>\n");}
;

mathsection: operand OPERATOR {fprintf(html,"<mo>%s</mo>\n",$2); } mathsection
		   | operand
;

mainbody: mainbody sectiontype mainbodycontent
		| mainbodycontent
		| sectiontype
;

mainbodycontent: formattedtextoption
			   | mathoption
;

formattedtextoption: BOLD LBRACE {fprintf(html,"<b>\n");} formattedtextoption RBRACE {fprintf(html,"</b>\n");}
				   | ITALIC LBRACE {fprintf(html,"<i>\n");} formattedtextoption RBRACE {fprintf(html,"</i>\n");}
				   | textoption
;

operand:  LETTERS POW {fprintf(html,"<mrow><msup>\n<mi>%s</mi>",$1); } operand {fprintf(html,"</msup></mrow>");}
		| INTEGER POW {fprintf(html,"<mrow><msup>\n<mn>%d</mn>",$1); } operand {fprintf(html,"</msup></mrow>");}
		| LETTERS POW {fprintf(html,"<mrow><msub>\n<mi>%s</mi>",$1); } operand {fprintf(html,"</msub></mrow>");}
		| INTEGER POW {fprintf(html,"<mrow><msub>\n<mn>%d</mn>",$1); } operand {fprintf(html,"</msub></mrow>");}
		| LETTERS {fprintf(html,"<mi>%s</mi>",$1); }  
		| INTEGER {fprintf(html,"<mn>%d</mn>",$1); }
;

textoption:  textoption WORD {fprintf(html," %s",$2); if(istitle) {strcat(title, " "); strcat(title, $2);}}
	      |  textoption INTEGER {fprintf(html," %d",$2);}
	      |  WORD {fprintf(html,"%s",$1); if(istitle) strcpy(title, $1);}
	      |  INTEGER {fprintf(html,"%d",$1); }
	      |  textoption BACKSLBACKSL {fprintf(html,"<br/>"); }
	      |  textoption HSPACE {fprintf(html,"&nbsp;"); }
	      |  textoption VSPACE {fprintf(html,"<br/>"); }
;

%%
int main(){
	html = fopen("latex.html","w+");
	return yyparse();
}

int yyerror (char *error) {
	return fprintf (stderr, "error: %s\n", error);
}
