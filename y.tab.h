/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    INT = 258,
    FLOAT = 259,
    BOOL = 260,
    STRING = 261,
    SEMICOLON = 262,
    TRUE = 263,
    FALSE = 264,
    OR = 265,
    AND = 266,
    EQL = 267,
    NEQ = 268,
    LEQ = 269,
    GEQ = 270,
    INC = 271,
    DEC = 272,
    ADD_ASSIGN = 273,
    SUB_ASSIGN = 274,
    MUL_ASSIGN = 275,
    QUO_ASSIGN = 276,
    REM_ASSIGN = 277,
    PRINT = 278,
    RETURN = 279,
    IF = 280,
    ELSE = 281,
    FOR = 282,
    WHILE = 283,
    CONTINUE = 284,
    BREAK = 285,
    VOID = 286,
    INT_LIT = 287,
    FLOAT_LIT = 288,
    STRING_LIT = 289,
    IDENT = 290
  };
#endif
/* Tokens.  */
#define INT 258
#define FLOAT 259
#define BOOL 260
#define STRING 261
#define SEMICOLON 262
#define TRUE 263
#define FALSE 264
#define OR 265
#define AND 266
#define EQL 267
#define NEQ 268
#define LEQ 269
#define GEQ 270
#define INC 271
#define DEC 272
#define ADD_ASSIGN 273
#define SUB_ASSIGN 274
#define MUL_ASSIGN 275
#define QUO_ASSIGN 276
#define REM_ASSIGN 277
#define PRINT 278
#define RETURN 279
#define IF 280
#define ELSE 281
#define FOR 282
#define WHILE 283
#define CONTINUE 284
#define BREAK 285
#define VOID 286
#define INT_LIT 287
#define FLOAT_LIT 288
#define STRING_LIT 289
#define IDENT 290

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 42 "compiler_hw2.y"

    int i_val;
    float f_val;
    char *s_val;

#line 133 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
