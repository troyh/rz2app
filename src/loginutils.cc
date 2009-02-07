extern "C" 
{
	#include <cgic.h>
}
#include <fstream>
#include <gcrypt.h>

#include "loginutils.h"

using namespace std;

LOGININFO::LOGININFO()
{
	memset(userid,0,sizeof(userid));
	memset(email,0,sizeof(email));
	memset(password,0,sizeof(password));
	memset(secret,0,sizeof(secret));
}

void getDomain(char* buffer,size_t bufsize)
{
	const char* lastdot=strrchr(cgiServerName,'.');
	if (!lastdot) // No dot at all, just an internal hostname, i.e., http://dev
	{
		memset(buffer,0,bufsize);
		// strncpy(buffer,".",bufsize);
		// strncat(buffer,cgiServerName,bufsize); // Copy the hostname as-is, no preceding dot
		// strncat(buffer,".local",bufsize);
		// buffer[bufsize-1]='\0';				  // null-terminate it
	}
	else // At least 1 dot, could be like either http://www.troyandgay.com, http://blah.blah.blah.troyandgay.com or http://troyandgay.com
	{
		// Walk backwards in cgiServerName to find the 2nd dot
		const char* p;
		for(p = lastdot-1; cgiServerName <= p; --p)
		{
			if (*p=='.')
			{
				break;
			}
		}
		++p; // We've gone too far, either past the start of cgiServerName or to the 2nd-to-last dot, so move back
	
		strncpy(buffer,".",bufsize); // make sure the first char is a dot
		strncat(buffer,p,bufsize);   // copy rest of domain
		buffer[bufsize-1]='\0';		// null-terminate it
	}
	
}

bool createLogin(const char* email, const char* password, const char* userid, const char* secret)
{
	if (!email || !strlen(email) ||
		!password || !strlen(password) ||
		!userid || !strlen(userid) ||
		!secret || !strlen(secret))
		return false;
	
	ofstream userdb("/tmp/userdb",ios::app);
	userdb << email << '\t'
		   << password << '\t'
		   << userid << '\t'
		   << secret << endl;
		
	return true;
}

LOGININFO* lookupLogin(const char* email)
{
	string ea,password,userid,secret;
	ifstream userdb("/tmp/userdb");
	while (userdb.good())
	{
		userdb >> ea >> password >> userid >> secret;
		if (!strcmp(ea.c_str(),email))
		{
			LOGININFO* login=new LOGININFO;

			strncpy(login->email,ea.c_str(),sizeof(login->email));
			strncpy(login->password,password.c_str(),sizeof(login->password));
			strncpy(login->userid,userid.c_str(),sizeof(login->userid));
			strncpy(login->secret,secret.c_str(),sizeof(login->secret));
			
			login->email   [sizeof(login->email   )-1]='\0';
			login->userid  [sizeof(login->userid  )-1]='\0';
			login->password[sizeof(login->password)-1]='\0';
			login->secret  [sizeof(login->secret  )-1]='\0';
			
			return login;
		}
	}
	
	return NULL;
}

void setLoginCookies(LOGININFO* login)
{
	// Get domain
	char domain[256];
	getDomain(domain,sizeof(domain));

	// Create the hash, which is an MD5 on of a concatenation of secretkey+userid+cgiRemoteAddr
	char to_be_hashed[256]="";
	strncat(to_be_hashed,login->secret,sizeof(to_be_hashed));
	strncat(to_be_hashed,login->userid,sizeof(to_be_hashed)-strlen(to_be_hashed));
	strncat(to_be_hashed,cgiRemoteAddr,sizeof(to_be_hashed)-strlen(to_be_hashed));
	to_be_hashed[sizeof(to_be_hashed)-1]='\0';

	char hash[32]="";
	gcry_check_version(0);
	gcry_md_hash_buffer(GCRY_MD_MD5,hash,to_be_hashed,strlen(to_be_hashed));
	
	char alphabet[]="abcdefghijklmnopqrstuvwxyz0123456789";
	for(size_t i = 0,j=strlen(hash); i < j; ++i)
	{
		hash[i]=alphabet[((unsigned char)hash[i]) % sizeof(alphabet)];
	}
	hash[sizeof(hash)-1]='\0';

		
	cgiHeaderCookieSetString("userid",login->userid,86400*14,"/",domain);
	cgiHeaderCookieSetString("usrkey",hash  ,86400*14,"/",domain);
}

void clearLoginCookies()
{
	char domain[256];
	getDomain(domain,sizeof(domain));
	
	cgiHeaderCookieSetString("userid","",-86400,"/",domain);
	cgiHeaderCookieSetString("usrkey","",-86400,"/",domain);
}

