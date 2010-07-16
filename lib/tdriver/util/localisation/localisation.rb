############################################################################
## 
## Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies). 
## All rights reserved. 
## Contact: Nokia Corporation (testabilitydriver@nokia.com) 
## 
## This file is part of Testability Driver. 
## 
## If you have questions regarding the use of this file, please contact 
## Nokia at testabilitydriver@nokia.com . 
## 
## This library is free software; you can redistribute it and/or 
## modify it under the terms of the GNU Lesser General Public 
## License version 2.1 as published by the Free Software Foundation 
## and appearing in the file LICENSE.LGPL included in the packaging 
## of this file. 
## 
############################################################################

# Utility for handling localisation database

module MobyUtil

	class Localisation

		DB_TYPE_MYSQL = 'mysql'
		DB_TYPE_SQLITE = 'sqlite'
		
		# Function for fetching translation  
		# == params
		# language:: String containing language to be used in fetching the translation
		# logical_name:: Symbol containing the logical name that acts as a key when fetching translation
		# table_name:: String containing the name of table to be used when fetching translation
		# == returns
		# String:: value of the localisation
		# == throws
		# LogicalNameNotFoundError:: in case the localisation for logical name not found
		# LanguageNotFoundError:: in case the language not found
		# TableNotFoundError:: in case the table name not found
		# MySqlConnectError:: in case of the other problem with the connectivity 
		def self.translation( logical_name, language, table_name )
			
			Kernel::raise LogicalNameNotFoundError.new( "Logical name cannot be nil" ) if logical_name == nil
			Kernel::raise LanguageNotFoundError.new( "Language cannot be nil" ) if language == nil
			Kernel::raise TableNotFoundError.new( "Table name cannot be nil" ) if table_name == nil
			
			# Get Localization parameters for DB Connection 
			db_type =  MobyUtil::Parameter[ :localisation_db_type, nil ].to_s.downcase
			host =  MobyUtil::Parameter[ :localisation_server_ip ]
			username = MobyUtil::Parameter[ :localisation_server_username ]
			password = MobyUtil::Parameter[ :localisation_server_password ]
			database_name = MobyUtil::Parameter[ :localisation_server_database_name ]
			
			query_string = "select `#{ language }` from #{ table_name } where lname = \'#{ logical_name }' and `#{ language }` <>\'#MISSING\'"
			
			begin
				result = MobyUtil::DBAccess.query( db_type, host, username, password, database_name, query_string )
			rescue        
				# if column referring to language is not found then Kernel::raise error for language not found
				Kernel::raise LanguageNotFoundError.new( "No language '#{ language }' found" ) unless $!.message.index( "Unknown column" ) == nil
				Kernel::raise MySqlConnectError.new( $!.message )
			end    
			
			# Validate result and return either a String or an Array
			### TODO take away the db_type dependency.. return Rows in a uniform way!!
			
			if db_type == DB_TYPE_MYSQL
			    Kernel::raise LogicalNameNotFoundError.new( "No logical name '#{ logical_name }' found for language '#{ language }'" ) if ( result.nil? || result.num_rows <= 0 )
				if ( result.num_rows() == 1 ) 
					return result.fetch_row[0]
				else
					result_array = []
					while( row = result.fetch_row )
						result_array << row[0]
					end			
					return result_array
				end
			elsif db_type == DB_TYPE_SQLITE
			    Kernel::raise LogicalNameNotFoundError.new( "No logical name '#{ logical_name }' found for language '#{ language }'" ) if ( result.nil? || result.to_a.size <= 0 )
				return result.to_a[0]
			end
			
		end

	end # class

end # module
