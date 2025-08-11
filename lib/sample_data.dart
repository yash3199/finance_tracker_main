// Data models and sample data for a personal finance tracker app
import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String languagePreference;
  final String currencyPreference;
  final bool onboardingCompleted;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.languagePreference,
    required this.currencyPreference,
    required this.onboardingCompleted,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
        languagePreference: json['languagePreference'],
        currencyPreference: json['currencyPreference'],
        onboardingCompleted: json['onboardingCompleted'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'languagePreference': languagePreference,
        'currencyPreference': currencyPreference,
        'onboardingCompleted': onboardingCompleted,
      };
}

class Category {
  final String id;
  final String name;
  final String icon;

  Category({required this.id, required this.name, required this.icon});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        name: json['name'],
        icon: json['icon'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
      };
}

class Transaction {
  final String id;
  final String type; // "income" or "expense"
  final double amount;
  final String category;
  final DateTime date;
  final String? description;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json['id'],
        type: json['type'],
        amount: json['amount'],
        category: json['category'],
        date: DateTime.parse(json['date']),
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'amount': amount,
        'category': category,
        'date': date.toIso8601String(),
        if (description != null) 'description': description,
      };
}

class Budget {
  final String id;
  final String categoryId;
  final double limit;
  final double spent;
  final double alertThreshold; // percentage

  Budget({
    required this.id,
    required this.categoryId,
    required this.limit,
    required this.spent,
    required this.alertThreshold,
  });

  factory Budget.fromJson(Map<String, dynamic> json) => Budget(
        id: json['id'],
        categoryId: json['categoryId'],
        limit: json['limit'],
        spent: json['spent'],
        alertThreshold: json['alertThreshold'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoryId': categoryId,
        'limit': limit,
        'spent': spent,
        'alertThreshold': alertThreshold,
      };
}

class CategoryBreakdownItem {
  final String categoryName;
  final double totalAmount;

  CategoryBreakdownItem({required this.categoryName, required this.totalAmount});

  factory CategoryBreakdownItem.fromJson(Map<String, dynamic> json) => CategoryBreakdownItem(
        categoryName: json['categoryName'],
        totalAmount: json['totalAmount'],
      );

  Map<String, dynamic> toJson() => {
        'categoryName': categoryName,
        'totalAmount': totalAmount,
      };
}

class Report {
  final String month; // e.g. "2025-08" or "2025"
  final double totalIncome;
  final double totalExpense;
  final List<CategoryBreakdownItem> categoryBreakdown;

  Report({
    required this.month,
    required this.totalIncome,
    required this.totalExpense,
    required this.categoryBreakdown,
  });

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        month: json['month'],
        totalIncome: json['totalIncome'],
        totalExpense: json['totalExpense'],
        categoryBreakdown: (json['categoryBreakdown'] as List)
            .map((e) => CategoryBreakdownItem.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'month': month,
        'totalIncome': totalIncome,
        'totalExpense': totalExpense,
        'categoryBreakdown': categoryBreakdown.map((e) => e.toJson()).toList(),
      };
}

// Sample Data
final sampleUser = User(
  id: 'u1',
  name: 'Alex Johnson',
  email: 'alex.johnson@email.com',
  password: 'securePass123',
  languagePreference: 'en',
  currencyPreference: 'USD',
  onboardingCompleted: true,
);

final sampleCategories = [
  Category(id: 'c1', name: 'Food', icon: '🍔'),
  Category(id: 'c2', name: 'Rent', icon: '🏠'),
  Category(id: 'c3', name: 'Salary', icon: '💼'),
  Category(id: 'c4', name: 'Bills', icon: '🧾'),
  Category(id: 'c5', name: 'Shopping', icon: '🛍️'),
];

final sampleTransactions = [
  Transaction(
    id: 't1',
    type: 'income',
    amount: 3000.0,
    category: 'Salary',
    date: DateTime(2025, 8, 1),
    description: 'Monthly salary',
  ),
  Transaction(
    id: 't2',
    type: 'expense',
    amount: 1200.0,
    category: 'Rent',
    date: DateTime(2025, 8, 2),
    description: 'August rent',
  ),
  Transaction(
    id: 't3',
    type: 'expense',
    amount: 250.0,
    category: 'Food',
    date: DateTime(2025, 8, 3),
    description: 'Groceries',
  ),
  Transaction(
    id: 't4',
    type: 'expense',
    amount: 80.0,
    category: 'Bills',
    date: DateTime(2025, 8, 5),
    description: 'Electricity bill',
  ),
  Transaction(
    id: 't5',
    type: 'expense',
    amount: 60.0,
    category: 'Food',
    date: DateTime(2025, 8, 7),
    description: 'Dining out',
  ),
  Transaction(
    id: 't6',
    type: 'expense',
    amount: 150.0,
    category: 'Shopping',
    date: DateTime(2025, 8, 10),
    description: 'Clothes',
  ),
  Transaction(
    id: 't7',
    type: 'income',
    amount: 200.0,
    category: 'Salary',
    date: DateTime(2025, 8, 15),
    description: 'Freelance project',
  ),
  Transaction(
    id: 't8',
    type: 'expense',
    amount: 40.0,
    category: 'Bills',
    date: DateTime(2025, 8, 18),
    description: 'Internet bill',
  ),
  Transaction(
    id: 't9',
    type: 'expense',
    amount: 90.0,
    category: 'Shopping',
    date: DateTime(2025, 8, 20),
    description: 'Books',
  ),
  Transaction(
    id: 't10',
    type: 'expense',
    amount: 30.0,
    category: 'Food',
    date: DateTime(2025, 8, 22),
    description: 'Snacks',
  ),
];

final sampleBudgets = [
  Budget(id: 'b1', categoryId: 'c1', limit: 400.0, spent: 340.0, alertThreshold: 80.0), // Food
  Budget(id: 'b2', categoryId: 'c2', limit: 1200.0, spent: 1200.0, alertThreshold: 100.0), // Rent
  Budget(id: 'b3', categoryId: 'c5', limit: 300.0, spent: 240.0, alertThreshold: 80.0), // Shopping
];

final sampleMonthlyReport = Report(
  month: '2025-08',
  totalIncome: 3200.0,
  totalExpense: 1940.0,
  categoryBreakdown: [
    CategoryBreakdownItem(categoryName: 'Food', totalAmount: 340.0),
    CategoryBreakdownItem(categoryName: 'Rent', totalAmount: 1200.0),
    CategoryBreakdownItem(categoryName: 'Bills', totalAmount: 120.0),
    CategoryBreakdownItem(categoryName: 'Shopping', totalAmount: 240.0),
  ],
);

final sampleYearlyReport = Report(
  month: '2025',
  totalIncome: 38400.0,
  totalExpense: 23280.0,
  categoryBreakdown: [
    CategoryBreakdownItem(categoryName: 'Food', totalAmount: 4080.0),
    CategoryBreakdownItem(categoryName: 'Rent', totalAmount: 14400.0),
    CategoryBreakdownItem(categoryName: 'Bills', totalAmount: 1440.0),
    CategoryBreakdownItem(categoryName: 'Shopping', totalAmount: 2880.0),
  ],
);

