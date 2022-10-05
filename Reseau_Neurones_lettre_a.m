sizeWord = 4;%taille du mot

ne = 5;%neurones entree
nc = 5;%neurones caches
ns = 1;%sortie

%initialisation des matrices avec poids
We = randi([1 10],7 * sizeWord,ne); %matrice entree

w = randi([0 20]-10,1,ne); %poids

We = [We ; w];

Wc = randi([1 10],ne - 1,nc);

w = randi([0 20]-10,1,nc);

Wc = [Wc ; w];

Ws = randi([1 10],nc - 1,ns);

w = randi([0 20]-10,1,ns);

Ws = [Ws ; w];

%generation de mots de 4 lettres aleatoires
s = 'abcdefghijklmnopqrstuvwxyz';
numRands = length(s);
Words = [];
WithA = [];
for c = 1:20000
    randString = s( ceil(rand(1,sizeWord)*numRands) );
    Words = [Words , string(randString)];
    WithA = [WithA , contains(string(randString),"a")];
end

%apprentissage
for i = 1 : 10000
    [We, Wc, Ws] = Regul(We,Wc,Ws,Words(i),WithA(i),sizeWord);
end

%test
tot = 0;%total de tests effectues
valid = 0;%tests correspondants
sup = 0;%faux positifs
min = 0;%faux negatifs

for i = 10001 : 20000
    b = reshape(de2bi(double(char(Words(i)))),sizeWord*7,1);
    b = [b ; 1];
    
    ye = We.' * b;
    for n = 1 : length(ye)
        ye(n) = OurHeaviside(ye(n));
    end
    yc = Wc.' * ye;
    for n = 1 : length(yc)
        yc(n) = OurHeaviside(yc(n));
    end
    ys = Ws.' * yc;
    for n = 1 : length(ys)
        ys(n) = OurHeaviside(ys(n));
    end
    tot = tot + 1;
    if ys == WithA(i)
        valid = valid + 1;
    else
        if ys == 1
            sup = sup + 1;
        else
            min = min + 1;
        end
    end
end

%affichage
valid
sup
min
tot

%fonction Heaviside
function oh = OurHeaviside(x)
    if x > 0
        oh = 1;
    else
        oh = 0;
    end
end

%mise a jour des matrices (du reseau de neurones)
function [r1, r2, r3] = Regul(We, Wc, Ws, word, withA, sizeWord)
    b = reshape(de2bi(double(char(word))),sizeWord*7,1);
    b = [b ; 1];
    
    ye = We.' * b;
    for n = 1 : length(ye)
        ye(n) = OurHeaviside(ye(n));
    end
    yc = Wc.' * ye;
    for n = 1 : length(yc)
        yc(n) = OurHeaviside(yc(n));
    end
    ys = Ws.' * yc;
    for n = 1 : length(ys)
        ys(n) = OurHeaviside(ys(n));
    end

    if withA ~= ys
        if ys == 1
            for n = 1 : length(ye)
                if ye(n) == 1
                    We(length(b),n) = We(length(b),n) + 1;
                    for m = 1 : length(b)-1
                        if b(m) == 1
                            We(m,n) = We(m,n) - 1;
                        end
                    end
                end
            end
            for n = 1 : length(yc)
                if yc(n) == 1
                    Wc(length(ye),n) = Wc(length(ye),n) + 1;
                    for m = 1 : length(ye)-1
                        if ye(m) == 1
                            Wc(m,n) = Wc(m,n) - 1;
                        end
                    end
                end
            end
            for n = 1 : length(ys)
                if ys(n) == 1
                    Ws(length(yc),n) = Ws(length(yc),n) + 1;
                    for m = 1 : length(yc)-1
                        if yc(m) == 1
                            Ws(m,n) = Ws(m,n) - 1;
                        end
                    end
                end
            end
        else
            for n = 1 : length(ye)
                if ye(n) == 0
                    We(length(b),n) = We(length(b),n) - 1;
                    for m = 1 : length(b)-1
                        if b(m) == 1
                            We(m,n) = We(m,n) + 1;
                        end
                    end
                end
            end
            for n = 1 : length(yc)
                if yc(n) == 0
                    Wc(length(yc),n) = Wc(length(yc),n) - 1;
                    for m = 1 : length(ye)-1
                        if ye(m) == 1
                            Wc(m,n) = Wc(m,n) + 1;
                        end
                    end
                end
            end
            for n = 1 : length(ys)
                if ys(n) == 0
                    Ws(length(ys),n) = Ws(length(ys),n) - 1;
                    for m = 1 : length(yc)-1
                        if yc(m) == 1
                            Ws(m,n) = Ws(m,n) + 1;
                        end
                    end
                end
            end
        end
    end
    r1 = We;
    r2 = Wc;
    r3 = Ws;
end

