%{
#include "y.tab.h"
#include<stdio.h>
#include<string.h>
%}

%%
"\\\\" 								{return BACKSLBACKSL;}
"\\"								{return BACKSL;}
"{" 								{return LBRACE;}
"}" 								{return RBRACE;}
"$"                     			{return DOLLAR;}
"^"                     			{return POW;}
"\\begin{document}" 				{return LBEGINDOCU;}
"\\end{document}" 					{return LENDDOCU;}
"\\documentclass"       			{return DOCUMENTCLASS;}
"\\textbf" 							{return BOLD;}
"\\textit" 							{return ITALIC;}
"article" 							{return ARTICLE;}
"proc" 								{return PROC;}
"letter" 							{return LETTER;}
"\\title"               			{return TITLE;}
"\\section"             			{return SECTION;}
"\\hspace"							{return HSPACE;}
"\\vspace"							{return VSPACE;}

(\%|\_|\&|\$|\#)					{return SPECCHAR;}
("+"|"-"|"=")     					{yylval.charval = strdup(yytext); return OPERATOR;}
[a-z]								{yylval.charval = strdup(yytext); return LETTERS;}
[0-9]+				    			{yylval.val = atoi(yytext); return INTEGER;}
((\.|\,|\!|\?|\:|\;)|[a-zA-Z0-9])+	{yylval.charval = strdup(yytext); return  WORD;}
%%
