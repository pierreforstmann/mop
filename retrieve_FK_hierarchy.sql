--
-- retrieve_FK_hierarchy.sql
--
-- assuming all tables belong to same schema
--

drop type MyTableType
;

create or replace type myScalarType as object 
  ( lvl	 number, 
   tname  varchar2(30) 
  ) 
/

create or replace type myTableType as table of myScalarType  
/

create or replace 
 function depends( p_table_name  in varchar2, 
    		       p_lvl in number default 1 ) return myTableType 
  authid_ current_user 
  as 
    	    l_data myTableType := myTableType(); 
    	    p_rname varchar2(30); 
     
   	    procedure recurse( p_cname in varchar2, 
   			               p_lvl   in number ) 
   	    is 
   	    p_rname varchar2(30); 
   	    begin 
   		if ( l_data.count > 1000 ) 
   		then 
   		    raise_application_error( -20001, 'probable loop' ); 
   		end if; 
   		for x in ( 
   		 select table_name, 
   			owner 
   			from user_constraints 
   			where constraint_name = p_cname 
   			and constraint_type = 'P' 
   		) 
   		loop 
   		   l_data.extend; 
   		   l_data(l_data.count) := myScalarType( p_lvl, x.table_name); 
  		   for y in ( 
   		   select r_constraint_name from user_constraints 
   		    where table_name = x.table_name and constraint_type = 'R') 
   		   loop 
   		    recurse( y.r_constraint_name, p_lvl+1); 
   		   end loop; 
   		end loop; 
  		exception when no_data_found 
   		 then return; 
   	    end; 
   	begin 
   	    l_data.extend; 
   	    for z in ( 
   	    select r_constraint_name from user_constraints 
   	      where table_name = p_table_name  
   	      and constraint_type = 'R' 
   	    ) 
   	    loop 
   	     l_data.extend; 
   	     l_data(l_data.count) := myScalarType( 1,  p_table_name); 
   	     recurse(z.r_constraint_name, 2 ); 
   	    end loop; 
   	    return l_data; 
   	end; 

/
