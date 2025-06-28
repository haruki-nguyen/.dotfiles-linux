function parseDrinkSalesData(inputText) {
    const lines = inputText.trim().split('\n');
    const salesData = [];
    let totalSales = 0;
    
    // Parse each line to extract drink name and quantity
    lines.forEach(line => {
        const match = line.match(/^(.+?):\s*(.*)$/);
        if (match) {
            const drinkName = match[1].trim();
            const quantityStr = match[2].trim();
            const quantity = quantityStr === '' ? 0 : parseInt(quantityStr) || 0;
            
            salesData.push({
                name: drinkName,
                quantity: quantity
            });
            
            totalSales += quantity;
        }
    });
    
    // Generate CSV in the specified format
    const header = 'Cà phê đen (hạt),Cà phê sữa,Cà phê muối,Bạc xỉu,Matcha latte,Cacao latte,Nước cam,Nước ngọt nói chung,Red bull,Trà đào,Trà vải,Trà tắc mật ong,Total cups';
    
    // Create data row with quantities in the same order as header
    const drinkOrder = [
        'Cà phê đen (hạt)', 'Cà phê sữa', 'Cà phê muối', 'Bạc xỉu', 
        'Matcha latte', 'Cacao latte', 'Nước cam', 'Nước ngọt nói chung',
        'Red bull', 'Trà đào', 'Trà vải', 'Trà tắc mật ong'
    ];
    
    // Create lookup map for quantities
    const quantityMap = {};
    salesData.forEach(item => {
        quantityMap[item.name] = item.quantity;
    });
    
    // Build data row with sale rates (%)
    const dataRow = drinkOrder.map(drink => {
        const quantity = quantityMap[drink] || 0;
        const saleRate = totalSales > 0 ? ((quantity / totalSales) * 100).toFixed(1) : '0.0';
        return saleRate;
    }).join(',') + ',' + totalSales;
    
    return header + '\n' + dataRow;
}

// Example usage with the provided input
const sampleInput = `Cà phê đen (hạt): 21
Cà phê sữa: 3
Cà phê muối: 5
Bạc xỉu: 3
Matcha latte: 5
Cacao latte: 2
Nước cam: 2
Nước ngọt nói chung: 2
Red bull: 
Trà đào: 1
Trà vải: 
Trà tắc mật ong:`;

console.log('Input:');
console.log(sampleInput);
console.log('\nOutput CSV:');
console.log(parseDrinkSalesData(sampleInput));

// Function to process multiple days data
function parseMultipleDays(daysData) {
    const results = [];
    
    Object.keys(daysData).forEach(day => {
        console.log(`\n=== ${day} ===`);
        const csvOutput = parseDrinkSalesData(daysData[day]);
        console.log(csvOutput);
        results.push({ day, csv: csvOutput });
    });
    
    return results;
}

// Example with multiple days
const multipleDaysData = {
    'Day 1': `Cà phê đen (hạt): 19
Cà phê sữa: 5
Cà phê muối: 1
Bạc xỉu: 3
Matcha latte: 2
Cacao latte: 4
Nước cam: 
Nước ngọt nói chung: 2
Red bull: 
Trà đào:
Trà vải: 
Trà tắc mật ong: 1`,
    
    'Day 2': `Cà phê đen (hạt): 23
Cà phê sữa: 7
Cà phê muối: 2
Bạc xỉu: 1
Matcha latte: 8
Cacao latte: 3
Nước cam: 3
Nước ngọt nói chung: 6
Red bull: 
Trà đào:
Trà vải: 
Trà tắc mật ong:`
};

console.log('\n\n=== MULTIPLE DAYS PROCESSING ===');
parseMultipleDays(multipleDaysData);
