clc % limpia pantalla
clear all % limpia todo
close all %cierra todo
warning off all  % apaga los warnings

newcolors = {'r','g','b','c','m','y','#0072BD','#D95319','#EDB120','#7E2F8E','#77AC30','#4DBEEE','#A2142F'};%se mandan llamar los colores

nc=input('¿Cuántas clases quieres?   ');%nc-> número de clases
npc=input('¿Cuántas representantes de clase quieres?   ');%npc-> número de representantes por clase

[nclx, ncly]=crearCl(nc,npc);   %Crear clases[nclx -> cord. x de n clases , ncly -> cord. y de n clases]

mdcl = medias(nc,nclx,ncly);%calculo de medias

flag=1;
while flag==1   % inicio loop
    vector=vecd(); %Entrada del vector desconocido

    vrnz=varianza(nc,npc,nclx,ncly, mdcl);
    %---Seleccionar clasificador
        clasi = input('--¿Qué clasificador deseas usar?-- \n 1.- Distancia Mínima \n2.- Máxima probabilidad (Bayes)\n');

        switch clasi
            case 1
                disMin(nc, vector, mdcl);
            case 2
                disbayes(nc, vector, mdcl, vrnz);
            otherwise
                disp('aun no disponible')
        end       
    
    graficando(nc, vector, nclx, ncly, newcolors);   
    
    flag=input('\n¿Desea agregar otro vector? 0 = No / 1 = Si \n');    
end %cierre loop
disp('fin del proceso');


%Funciones -----

%function Distancia mínima
function disMin(n, v, med) %nclases, vector, media(s)
%dstclss -> distancias
    for f1=1:n
        dstclss(:,f1)=norm(v-med(:,f1));%calculo de la distancia
    end
    minimo=min(min(dstclss));
    valor=find(dstclss==minimo);
    fprintf('\n\nDISTANCIA MÍNIMA:\nEl vector  pertenece a la clase \"%d\"\n',valor);

end

%funcion Bayes
function disbayes(n, v, med,var) %nclases, vector, media(s), varinza(s)
    %llamada a h = resta de vector menos media
    pbayes=[];
    for f1=1:n
        datum1=subvecymed(n, v, med(:,f1));
        dato1=datum1;
        datum1t=dato1'; %transpuesta
        inversa=var(:,:,f1)';
        sideb=exp(-0.5*dato1*inversa*datum1t); 
        sidea=((1/(2*pi))*det(var(:,:,f1))^(-0.5));
        bayes=sidea*sideb; 
        pbayes=[pbayes, bayes];
    end
        
        %normalizando las probabilidades    
    sumprob=sum(pbayes);
    probfinal=pbayes/sumprob;
    probmax=max(max(probfinal));
    probmax1=find(probfinal==probmax);
    fprintf('\n\nMAXIMA PROBABILIDAD:\nEl vector  pertenece a la clase \"%d\"\n',probmax1);     
end

%funcion varianza
function var=varianza(n,r,cx,cy, m) %nclases, repeticiones Clases, x de clase, y de clase, media(s)
    for f1=1:n
        aux=[ cx(:,:,f1)-m(1,f1); cy(:,:,f1)-m(2,f1)];
        aux1=aux';
        var(:,:,f1)=(1/r)*(aux*aux1);
    end
end

function graficando(n,v,cx,cy,color) %nclases, vector, cord.x de clase , cord.y de clase, colores
    cla reset; %"limpiar" la figura
    figure(1)
    grid on
    hold on
    txtlegend={}; %arreglo de las leyendas
    xlabel('Coordenada X');
    ylabel('Coordenada Y');
    title('Gráfica de Clases y vector');
    for f1=1:n   %Impresion de las clases
        plot(cx(1,:,f1),cy(1,:,f1),'ko','MarkerSize',10,'MarkerFaceColor',color{f1})%impresion de la (f1) clase      
            name=sprintf('Clase %d',f1);
            txtlegend=[txtlegend,name]; %Añadido a leyenda
    end
    plot(v(1,:),v(2,:),'kp','MarkerSize',10,'MarkerFaceColor','w')%impresión de punto de vector 
    txtlegend=[txtlegend,'Vector'];
    legend(txtlegend);
end

%creación de clases random
function [x,y] = crearCl(n,r) %nclases, repeticiones

    for f1=1:n
       x(:,:,f1)=randn(1,r);
       y(:,:,f1)=randn(1,r);
    end
    [x,y]=alterar(n,x,y);
    
end

%funcion para introducir centroides y dispersión
function [ax,ay]= alterar(n, x, y) %nclases, cord.x de clase , cord.y de clase
    ax=x;
    ay=y;
    for f1=1:n
       fprintf('Introduce el centroide en x de la clase %d   ',f1);
       temCent=input('');%variable que almacena valor del centroide x
       ax(:,:,f1)=ax(:,:,f1)+temCent;
       fprintf('Introduce el centroide en y de la clase %d   ',f1);
       temCent=input('');%variable que almacena valor del centroide y
       ay(:,:,f1)=ay(:,:,f1)+temCent;
       fprintf('\n');
    end       
        
    for f1=1:n
       fprintf('Introduce la disperción de la clase %d   ',f1);
       temCent=input('');
       ax(:,:,f1)=ax(:,:,f1)*temCent;
       ay(:,:,f1)=ay(:,:,f1)*temCent;
    end      
end

function med = medias(n,x,y) %nclases, cord.x de clase , cord.y de clase
    a=[x;y];
    for f1=1:n
       med(:,f1)=mean(a(:,:,f1),2);
    end
end

%vecd = función que guarda el vector
function v = vecd()
    vx=input('Coordenada del vector en x=  ');
    vy=input('Coordenada del vector en y=  ');
    v=[vx;vy];
    fprintf('\n');
end

%resta de x vector menos media
function h = subvecymed(n, v, med)
 
   %acceder a elementos de media
   h=[v(1)-med(1) v(2)-med(2)];
end
