// Interfaces
interface Billable {
  bill(): void;
}

// Enum
enum Rating {
  GOOD,
  OK,
  POOR,
}

// Classes
abstract class Item implements Billable {
  abstract print(): void;

  bill(): void {
    // Implementation for billing
  }
}

class Review {
  constructor(public rating: Rating) {}
}

class StockItem extends Item {
  private review: Review;
  private name: string;

  constructor(name: string, rating: Rating) {
    super();
    this.name = name;
    this.review = new Review(rating);
  }

  print(): void {
    // Implementation for printing
  }

  bill(): void {
    // Implementation for billing
  }
}

class Inventory {
  private items: Item[] = [];

  getItemCount(): number {
    return this.items.length;
  }

  generateBill(b: Billable): void {
    // Implementation for generating a bill
  }

  add(s: Item): void {
    this.items.push(s);
  }
}
