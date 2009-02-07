extern "C"
{
#include <cgic.h>
}

#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <string.h>

using namespace std;

int cgiMain()
{
	// TODO: verify that the user's id can be trusted! If not, redirect to cgi-bin/login
	
	char* doctype="document";
	if (cgiPathInfo && strlen(cgiPathInfo))
	{
		doctype=cgiPathInfo+1; // +1 skips initial slash
		// Truncate at the first non-alphanumeric, underscore or hyphen char
		for(char* p = doctype; *p; ++p)
		{
			if (!isalnum(*p) && *p!='_' && *p!='-')
			{
				*p='\0';
				break;
			}
		}
		// TODO: verify that the doctype, which is supplied by the user, is controlled, i.e., not a security risk
	}
	
	char xmlFileLoc[256];
	sprintf(xmlFileLoc,"/tmp/%lu-%d-%d.xml",,,);
	FILE* xmlOut=fopen(xmlFileLoc,"w");
	if (!xmlOut)
	{
		// TODO: handle this (500 Internal Server error?)
	}
	else
	{
		fprintf(xmlOut,"<post>");
		fprintf(xmlOut,"<cgi>");
	
		if (strlen(cgiAuthType))
			fprintf(xmlOut,"<AuthType>%s</AuthType>",cgiAuthType);
		if (strlen(cgiRemoteHost))
			fprintf(xmlOut,"<RemoteHost>%s</RemoteHost>",cgiRemoteHost);
		if (strlen(cgiRemoteAddr))
			fprintf(xmlOut,"<RemoteAddr>%s</RemoteAddr>",cgiRemoteAddr);
		if (strlen(cgiRemoteIdent))
			fprintf(xmlOut,"<RemoteIdent>%s</RemoteIdent>",cgiRemoteIdent);
		
		char** cookies;
		cgiCookies(&cookies);
		if (cookies[0])
		{
			fprintf(xmlOut,"<cookies>");
			for(size_t i = 0; cookies[i]; ++i)
			{
				char buf[256];
				cgiFormString(cookies[i],buf,sizeof(buf));
				fprintf(xmlOut,"<%s>",cookies[i]);
				cgiHtmlEscape(buf);
				fprintf(xmlOut,"</%s>",cookies[i]);
			}
			cgiStringArrayFree(cookies);
	
			fprintf(xmlOut,"</cookies>");
		}
		fprintf(xmlOut,"</cgi><doc><%s>",doctype);

		char content_type[256];
		cgiFormResultType res=cgiFormFileContentType("file",content_type,sizeof(content_type));
		if (res==cgiFormNoContentType || res==cgiFormNotFound)
		{
			char** fields;
			cgiFormEntries(&fields);
			for(size_t i = 0; fields[i]; ++i)
			{
				char buf[4096];
				cgiFormString(fields[i],buf,sizeof(buf));
				fprintf(xmlOut,"<%s>",fields[i]);
				cgiHtmlEscape(buf);
				fprintf(xmlOut,"</%s>",fields[i]);
			}
			cgiStringArrayFree(fields);
		}
		else if (!strcasecmp(content_type,"text/xml"))
		{
			// Write the XML doc as-is
			while (!feof(cgiIn))
			{
				char buf[4096];
				size_t n=fread(buf,sizeof(char),cgiContentLength<sizeof(buf)?cgiContentLength:sizeof(buf),cgiIn);
				fwrite(buf,sizeof(char),n,xmlOut);
			}
		}
		else
		{
			// TODO: what to do?
			// cout << "Unknown content-type: " << content_type << endl;
		}

		fprintf(xmlOut,"</%s></doc></post>",doctype);
		fclose(xmlOut);

		/*
		 * Run the app's command to process it
		 */
		char command[512];
		sprintf(command,"%s/%s/bin/post/%s %s",wwwroot,appprefix,doctype,xmlFileLoc);
		FILE* appcgi=popen(command,"r");
		if (appcgi)
		{
			// Read output of command, that's the XML used for the XSL
			
			int ret=pclose(appcgi);
			
			if (ret==0)
			{			
				/*
				 * Ok, generate output using "good" XSL stylesheet
				 */
			}
			else
			{
				/*
				 * Error, generate output using "bad" XSL stylesheet
				 */
			}
		}
		
	}
	
	return 0;
}

// Static Content
// Indexed
// Documents
// XML + XSL
// Application
// Webapp
// High-performance/Fast
// Reliable
// Simple
// 
// SIXD
// DXS
// SIDSX (Static Indexed Documents Served by XML)
// SIDXAWHPSFR
// SWAIDXHPSFR
// RADIX (Reliable App Documents Indexed XML/XSL)  

