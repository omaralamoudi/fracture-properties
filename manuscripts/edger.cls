%% Authors: [https://github.com/debanjanamex](original)
%%   				David Tang
%% 				Omar Alamoudi (current maintainer)
%% Updates:
%% 				Feb 3, 2020:	fine tune and cleaned up the document. Further improvement is needed
%% 				Jan x, 2020:		File was worked on becuase EDGER meeting was approaching

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{edger}[2020/01/24 EDGER manuscript latex template]
\LoadClass[12pt]{article}

% Bibliography package
\RequirePackage{natbib}

% 	DOCUMENT STYLE AND APPEARANCE
% Setting up document margins
\RequirePackage[margin=1in,headheight=0.5in]{geometry}

% indents the first paragraph of the first paragraph in each sub/section
\RequirePackage{indentfirst}				

% Set line spacing
\linespread{1.25}

% Setting up figure and table captions  {
\usepackage{caption}
\captionsetup{
margin				=0.25in,
format				=hang,
hangindent		=-0.25in,
justification  	=justified,
skip					=1pt,
font					={footnotesize,bf},
labelsep			=period
}
\captionsetup[table]{
position 		=above
}
%} caption setup --end--

% DEFINING DIFFERENT PAGE STYLES {
\usepackage{fancyhdr}
\fancypagestyle{shorttitle}
{%
	\fancyhf{}
	\fancyfoot[c]{\small \thepage}
	\fancyhead[c]{\small \shorttitle}
	\renewcommand{\headrulewidth}{0pt}
	\renewcommand{\footrulewidth}{0pt}
}

\fancypagestyle{plain}
{%
	\fancyhf{}
	\fancyfoot[c]{\small \thepage}
	\renewcommand{\headrulewidth}{0pt}
	\renewcommand{\footrulewidth}{0pt}
}
%} page style --end--

% Setting the font to Times New Roman
% ---------------------------------------------------
% Alternative method: you can uncomment the following two
% lines and use either XeLatex or LuaLatex
%\usepackage{fontspec}
%\setmainfont{Times New Roman}
% ---------------------------------------------------
\usepackage{tgtermes}
\usepackage{mathptmx}

% \usepackage{subcaption}

% Setting up the document headers 
\usepackage{graphicx} 		% graphics package
\usepackage{lipsum}
\usepackage{blindtext} % I prefer this over lipsum
\usepackage{etoolbox}

\usepackage{setspace}

%{ section header text style
\usepackage{sectsty}
\sectionfont{\normalsize \bfseries \MakeUppercase } % sets the size of the header to normal size, bold faces, and make it upper case
\subsectionfont{\normalsize \bfseries}
%}

%{ abstract box
\usepackage{mdframed} 		% used to frame the abstract
\newmdenv[					% defining an abstract environment using the mdframed command \newmdenv
% box properties
linewidth					=0.5pt,
skipabove					=6pt,	% top margin
innertopmargin		=6pt,
leftmargin				=0pt,
innerleftmargin		=5pt,
skipbelow					=4pt,	% bottom margin
innerbottommargin	=6pt,
rightmargin				=0,
innerrightmargin		=5pt,
% Setting up the abstract title and its properties
frametitle					=ABSTRACT,
frametitlealignment	=\center,
frametitleaboveskip	=8pt
]{edgerabstract}
%} abstract box --end--

% Misc. packages
\usepackage{xcolor}
% Loading math packages
\RequirePackage{amsmath}					% Math package
\RequirePackage{mathtools}

% NEW COMMANDS
\newcommand{\conftitle}{The 7th International Conference on...}	
\newcommand{\shorttitle}[1]{\chead{\small \textcolor{black}{{\MakeUppercase #1}}}}

% Format the title of the manuscript
\newcommand{\edgertitle}[1] %~~~ This used to be \renewcommand{\title}
{ 
\begin{center}
\textbf{\uppercase{#1}}
\end{center}
}

% Formatting the authors
\newcommand{\edgerauthor}[1]
{ 
\begin{center}
\textbf{#1}
\end{center}
}


\newcommand{\institution}
{ 
\begin{center}
\textit{{Department of Geological Sciences\\ 
			The University of Texas at Austin}}
\end{center}
}

% I want to discard the following command
\newcommand\plot[3]{
	\begin{figure}
		\centering
		\includegraphics[#2]{#1}
		\captionsetup{width=\dimexpr\textwidth-2cm\relax}
		\caption{#3}
		\label{fig:#1}
	\end{figure}
}


\newcommand\multiplot[3]{
		\centering
		\includegraphics[#2]{#1}
		\caption{#3}
		\label{fig:#1}
}

%Defines table command
\newcommand{\tabl}[4]
{
\begin{table}
{#3}
\captionsetup{width=\dimexpr\textwidth-2cm\relax}
\caption{#2}
\label{tabl:#1}
\end{table}
}

% Setting graphics path where figures that will be added to the paper are included
\graphicspath{{./figures/}} % this needs to be removed

\AtBeginEnvironment{thebibliography}{\linespread{1}\selectfont}
\def\bibfont{\small}