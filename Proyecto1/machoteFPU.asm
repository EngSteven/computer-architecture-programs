.model small
.stack 100h 
.386
.data 


.code 
 start:
		mov 	ax,@data 
		mov 	ds,ax 
 
 salir:		
		mov 	eax,4c00h
		int 	21h
end start