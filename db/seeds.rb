# -*- coding: utf-8 -*-
Period.where(name: 'BREAKFAST').first_or_create
Period.where(name: 'LUNCH').first_or_create
Period.where(name: 'VEGETARIAN LUNCH').first_or_create
Period.where(name: 'DINNER').first_or_create
Period.where(name: 'VEGETARIAN DINNER').first_or_create
# Lunch and Dinner
Period.where(name: 'BOTH').first_or_create

University.where(name: 'UFAC',
                        long_name: 'Universidade Federal do Acre',
                        class_name: 'Parser::UfacParser',
                        website: 'http://proplan.ufac.br/cardapio-ru/').first_or_create

University.where(name: 'UEL',
                 long_name: 'Universidade Estadual de Londrina',
                 class_name: 'Parser::UelParser',
                 website: 'http://www.uel.br/ru/pages/cardapio.php').first_or_create

University.where(name: 'UEM',
                 long_name: 'Universidade Estadual de Maringá',
                 class_name: 'Parser::UemParser',
                 website: 'http://www.dct.uem.br/cardapio.htm').first_or_create

University.where(name: 'Cambridge',
                 long_name: 'University of Cambridge',
                 class_name: 'Parser::CambridgeParser',
                 website: 'http://www.unicen.cam.ac.uk/food-and-drink/main-dining-hall').first_or_create
