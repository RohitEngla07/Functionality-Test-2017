hold on

plot3(cat1(:,1) , cat1(:,2) , cat1(:,3) , '*' , 'Color' , 'yellow');
plot3(cat2(:,1) , cat2(:,2) , cat2(:,3) , '*' , 'Color' , 'green');
plot3(cat3(:,1) , cat3(:,2) , cat3(:,3) , '*' , 'Color' , 'blue');

plot3(cat4(:,1) , cat4(:,2) , cat4(:,3) , '*' , 'Color' , 'magenta');
plot3(cat5(:,1) , cat5(:,2) , cat5(:,3) , '*' , 'Color' , 'red');
plot3(cat6(:,1) , cat6(:,2) , cat6(:,3) , '*' , 'Color' , 'black');

filename = sprintf( '%s %i %s' , 'monte_carlo_results_' , N , '_cases.fig')
saveas(gcf , filename);